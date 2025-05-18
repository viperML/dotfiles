import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import { bind, GLib, Variable } from "astal"

import Hyprland from "gi://AstalHyprland"

function Workspaces() {
    const hypr = Hyprland.get_default()

    return <box cssClasses={["Workspaces"]}>
        {bind(hypr, "workspaces").as(wss => wss
            .filter(ws => !(ws.id >= -99 && ws.id <= -2)) // filter out special workspaces
            .sort((a, b) => a.id - b.id)
            .map(ws => (
                <button
                    cssClasses={bind(hypr, "focusedWorkspace").as(fw =>
                        ws === fw ? ["focused"] : [])}
                    onClicked={() => ws.focus()}>
                    {ws.id}
                </button>
            ))
        )}
    </box>
}

function Time() {
    const time = Variable<string>("").poll(1000, () =>
        GLib.DateTime.new_now_local().format("%A %d %B - %H:%M")!)

    return <label
        cssClasses={["Time"]}
        onDestroy={() => time.drop()}
        label={time()}
    />
}

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return <window
        visible
        cssClasses={["Bar"]}
        gdkmonitor={gdkmonitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}
        application={App}>

        <centerbox>
            <box>
                <label>Boo</label>
            </box>

            <box>
                <Workspaces/>
            </box>

            <box>
                <Time/>
            </box>
        </centerbox>
    </window>
}
