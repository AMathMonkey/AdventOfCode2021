input: 0 $ 0: "input.txt"
gi: {(!^x)[& ,//x]} / get indices of non-zero values
table: input +/: input
indices: * gi[(^table) # (,//2020 - table) _in\: input]
*/ input[indices, input?(2020 - +/ input[indices])]
\\
