NB. Get boxed indices of 1s, phrase m20 from https://www.jsoftware.com/help/phrases/locate_select.htm
gbi =: [: (<"1) ($ #: (# i.@$)@,)

input =: ". ;._2 fread 'input.txt'
*/ (> {. gbi 2020 = +/~ input) { input