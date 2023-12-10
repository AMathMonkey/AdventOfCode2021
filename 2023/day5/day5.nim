import strutils
import sequtils
import sugar

let lines = lines("input.txt").toSeq

type Range = (int, int)
type InputRange = (int, int, int)

proc getMappings(sourceRanges: var seq[Range], mapvar: seq[InputRange]): seq[Range] =
  while sourceRanges.len > 0:
    let 
      (thisStart, thisLength) = sourceRanges.pop
      thisEnd = thisStart + thisLength - 1
    var thisResult: seq[Range]
    for (destStart, sourceStart, length) in mapvar:
      let sourceEnd = sourceStart + length - 1
      if thisStart >= sourceStart and thisStart <= sourceEnd and thisEnd >= sourceStart and thisEnd <= sourceEnd:
        thisResult.add((destStart + thisStart - sourceStart, thisLength))
      elif sourceStart >= thisStart and sourceStart <= thisEnd and sourceEnd >= thisStart and sourceEnd <= thisEnd:
        thisResult.add((destStart, length))
        block:
          let len = sourceStart - thisStart
          if len > 0: sourceRanges.add((thisStart, len))
        block:
          let len = thisEnd - sourceEnd
          if len > 0: sourceRanges.add((sourceEnd + 1, len))
      elif thisStart >= sourceStart and thisStart <= sourceEnd:
        thisResult.add((destStart + thisStart - sourceStart, sourceEnd - thisStart))
        let len = thisLength - sourceEnd - thisStart
        if len > 0: sourceRanges.add((sourceEnd + 1, len))
      elif thisEnd >= sourceStart and thisEnd <= sourceEnd:
        thisResult.add((destStart, thisLength - sourceStart - thisStart))
        let len = sourceStart - thisStart
        if len > 0: sourceRanges.add((thisStart, len))
    if thisResult.len == 0:
      thisResult.add((thisStart, thisLength))
    for r in thisResult: result.add(r)
    
proc indexOfNextBlank(lines: seq[string], start: int): int = 
  for i in start ..< lines.len:
    if lines[i].isEmptyOrWhitespace: return i
  return lines.len

proc getMapping(sourceVal: int, mapVar: seq[InputRange]): int = 
  for (destStart, sourceStart, length) in mapVar:
    if sourceVal >= sourceStart and sourceVal < sourceStart + length:
      return destStart + sourceVal - sourceStart
  return sourceVal

var 
  seeds: seq[int]
  seedToSoil: seq[InputRange]
  soilToFertilizer: seq[InputRange]
  fertilizerToWater: seq[InputRange]
  waterToLight: seq[InputRange]
  lightToTemperature: seq[InputRange]
  temperatureToHumidity: seq[InputRange]
  humidityToLocation: seq[InputRange]

block:
  var i: int = 0
  while i < lines.len:
    let line = lines[i]
    if line.startsWith("seeds:"):
      seeds =  line.split(": ")[1].split.mapIt(it.parseInt)
      i.inc 2
    else:
      let nextIndex = indexOfNextBlank(lines, i)
      if line.startsWith("seed-to-soil"):
        for line in lines[i + 1 ..< nextIndex]:
          let words = line.split.mapIt(it.parseInt)
          seedToSoil.add((words[0], words[1], words[2]))
      elif line.startsWith("soil-to-fertilizer"):
        for line in lines[i + 1 ..< nextIndex]:
          let words = line.split.mapIt(it.parseInt)
          soilToFertilizer.add((words[0], words[1], words[2]))
      elif line.startsWith("fertilizer-to-water"):
        for line in lines[i + 1 ..< nextIndex]:
          let words = line.split.mapIt(it.parseInt)
          fertilizerToWater.add((words[0], words[1], words[2]))
      elif line.startsWith("water-to-light"):
        for line in lines[i + 1 ..< nextIndex]:
          let words = line.split.mapIt(it.parseInt)
          waterToLight.add((words[0], words[1], words[2]))
      elif line.startsWith("light-to-temperature"):
        for line in lines[i + 1 ..< nextIndex]:
          let words = line.split.mapIt(it.parseInt)
          lightToTemperature.add((words[0], words[1], words[2]))
      elif line.startsWith("light-to-temperature"):
        for line in lines[i + 1 ..< nextIndex]:
          let words = line.split.mapIt(it.parseInt)
          lightToTemperature.add((words[0], words[1], words[2]))
      elif line.startsWith("temperature-to-humidity"):
        for line in lines[i + 1 ..< nextIndex]:
          let words = line.split.mapIt(it.parseInt)
          temperatureToHumidity.add((words[0], words[1], words[2]))
      elif line.startsWith("humidity-to-location"):
        for line in lines[i + 1 ..< nextIndex]:
          let words = line.split.mapIt(it.parseInt)
          humidityToLocation.add((words[0], words[1], words[2]))
      i = nextIndex + 1
    
block:
  var min = int.high
  for seed in seeds:
    let
      soil = getMapping(seed, seedToSoil)
      fertilizer = getMapping(soil, soilToFertilizer)
      water = getMapping(fertilizer, fertilizerToWater)
      light = getMapping(water, waterToLight)
      temperature = getMapping(light, lightToTemperature)
      humidity = getMapping(temperature, temperatureToHumidity)
      location = getMapping(humidity, humidityToLocation)
    if location < min: min = location
  echo "Part 1: ", min

block:
  var
    min = int.high
    seedPairs: seq[Range] = collect:
      for i in countup(0, seeds.len - 2, 2):
        (seeds[i], seeds[i + 1])
    soils = getMappings(seedPairs, seedToSoil)
    fertilizers = getMappings(soils, soilToFertilizer)
    waters = getMappings(fertilizers, fertilizerToWater)
    lights = getMappings(waters, waterToLight)
    temperatures = getMappings(lights, lightToTemperature)
    humidities = getMappings(temperatures, temperatureToHumidity)
    locations = getMappings(humidities, humidityToLocation)
  for (location, _) in locations:
    if location < min: min = location
  echo "Part 2: ", min
