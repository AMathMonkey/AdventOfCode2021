input: 0:"input.txt"
rows: *^input
+/ "#" = input ./: (+!rows) ,' + (3 * !rows) !/: (^input[1])
\\
