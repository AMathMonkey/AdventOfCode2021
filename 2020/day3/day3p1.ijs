input =: [;._2 fread 'input.txt'
'rows cols' =: $input
+/ '#' = input {~ <"1 (] ,. (cols | 3 * ])) i. rows
