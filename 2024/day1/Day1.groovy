class Day1 {

    static void main(String[] args) {
        List pairs = ('input.txt' as File).readLines().collect {
            it.split()*.toInteger()
        }.transpose().each(List.&sort).transpose()
        int diff = pairs.sum { left, right -> Math.abs(left - right) }

        Map rightCounts = pairs.countBy { left, right -> right }
        int score = pairs.sum { left, right ->
            left * (rightCounts[left] ?: 0)
        }
        println("Part 1: ${diff}\nPart 2: ${score}")
    }

}
