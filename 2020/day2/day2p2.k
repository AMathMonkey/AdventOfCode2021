input: 0: "input.txt"
parse: {
    start: x ? "-"
    end: start + 1 + ((start + 1) _ x) ? " "
    chr: end + 1 + ((end + 1) _ x) ? ":"
    parsed: (0,start,end,chr) _ x
    ((0 $ parsed[0]) ; (0 $ 1 _ parsed[1]) ; (parsed[2][1]) ; (2 _ parsed[3]))}
valid: {
    pos1: x[0] - 1; pos2: x[1] - 1; letter: x[2]; string: x[3]
    ~ (string[pos1] = letter) = (string[pos2] = letter)}
+/ valid' parse' input
\\
