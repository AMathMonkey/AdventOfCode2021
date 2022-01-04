input: 0:"input.txt"
rows: *^input
solve: {[right; down]
    rowi: (down * !rows)[& rows > down * !rows]
    +/ "#" = input ./: rowi ,' + (right * !#rowi) !/: (^input[1])}
*/ solve[1;2],solve[7;1],solve[5;1],solve[3;1],solve[1;1]
\\
