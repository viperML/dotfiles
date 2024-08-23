/**
 * @import { Variable as VariableT } from "./types/variable"
 */

/**
 * @param {VariableT<number>} _var
 */
function incLoop(_var) {
  _var.value++;
  setTimeout(() => incLoop(_var), 1000);
}

const myVar = Variable(0);

incLoop(myVar);


const myBar = Widget.Window({
  name: "bar",
  anchor: ["bottom", "left", "right"],
  class_name: "bar",
  exclusivity: "exclusive",
  child: Widget.Label({
    label: myVar.bind().as(v => `value: ${v}`)
  }),
})

App.config({
  style: 'style.css',
  windows: [
    myBar
  ]
})
