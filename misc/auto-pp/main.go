package main

import (
	"log"
	"os"

	"github.com/godbus/dbus/v5"
)

const (
	upowerDest         = "org.freedesktop.UPower"
	upowerPath         = "/org/freedesktop/UPower"
	upowerIface        = "org.freedesktop.UPower"
	ppdDest            = "net.hadess.PowerProfiles"
	ppdPath            = "/net/hadess/PowerProfiles"
	ppdIface           = "net.hadess.PowerProfiles"
	dbusPropsIface     = "org.freedesktop.DBus.Properties"
)

func setProfile(conn *dbus.Conn, profile string) error {
	obj := conn.Object(ppdDest, ppdPath)
	err := obj.Call(
		dbusPropsIface+".Set",
		0,
		ppdIface,
		"ActiveProfile",
		dbus.MakeVariant(profile),
	).Err
	if err != nil {
		return err
	}
	log.Printf("Power profile set to: %s", profile)
	return nil
}

func main() {
	logger := log.New(os.Stdout, "[power-switcher] ", log.LstdFlags)

	conn, err := dbus.ConnectSystemBus()
	if err != nil {
		logger.Fatalf("Failed to connect to system D-Bus: %v", err)
	}
	defer conn.Close()

	// Subscribe to UPower PropertiesChanged signals
	if err := conn.AddMatchSignal(
		dbus.WithMatchObjectPath(upowerPath),
		dbus.WithMatchInterface(dbusPropsIface),
		dbus.WithMatchMember("PropertiesChanged"),
		dbus.WithMatchSender(upowerDest),
	); err != nil {
		logger.Fatalf("Failed to subscribe to UPower signals: %v", err)
	}

	// Read initial state and set profile on startup
	obj := conn.Object(upowerDest, upowerPath)
	var onBattery bool
	if err := obj.Call(dbusPropsIface+".Get", 0, upowerIface, "OnBattery").Store(&onBattery); err != nil {
		logger.Printf("Warning: could not read initial OnBattery state: %v", err)
	} else {
		profile := profileFor(onBattery)
		logger.Printf("Initial state — OnBattery: %v → setting profile to %q", onBattery, profile)
		if err := setProfile(conn, profile); err != nil {
			logger.Printf("Warning: could not set initial profile: %v", err)
		}
	}

	logger.Println("Listening for UPower property changes...")

	c := make(chan *dbus.Signal, 10)
	conn.Signal(c)

	for signal := range c {
		if signal.Path != upowerPath || signal.Name != dbusPropsIface+".PropertiesChanged" {
			continue
		}

		// PropertiesChanged args: (string interface, map[string]Variant changed, []string invalidated)
		if len(signal.Body) < 2 {
			continue
		}

		changed, ok := signal.Body[1].(map[string]dbus.Variant)
		if !ok {
			continue
		}

		variant, ok := changed["OnBattery"]
		if !ok {
			continue
		}

		onBattery, ok := variant.Value().(bool)
		if !ok {
			continue
		}

		profile := profileFor(onBattery)
		logger.Printf("OnBattery changed to %v → switching profile to %q", onBattery, profile)

		if err := setProfile(conn, profile); err != nil {
			logger.Printf("Error setting profile: %v", err)
		}
	}
}

func profileFor(onBattery bool) string {
	if onBattery {
		return "balanced"
	}
	return "performance"
}
