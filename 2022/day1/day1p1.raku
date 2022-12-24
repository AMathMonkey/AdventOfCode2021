my Int @currentElf;
my Array[Int] @elves = gather for 'input.txt'.IO.lines -> $line {
  if $line {@currentElf.push: $line.Int}
  else {take @currentElf.splice}
}
say @elves>>.sum.max
