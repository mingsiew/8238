


dirname = Dir.pwd
fileName = dirname + '/iomap.iom'
modules = Array.new
exclusionList = Array.new

file = File.open(fileName)
file.each do |line|
  if line.include? "X["
    pos1 = line.index("X[") + 2
    pos2 = line.index("].X") - 1
    number = line[pos1..pos2]
    pos1 = line.index("%IX.") + 4
    pos2 = line.index(".DigitalInput") - 1
    name = line[pos1..pos2]
    modules << [number,name]
  elsif line.include? "Y["
    pos1 = line.index("Y[") + 2
    pos2 = line.index("].Y") - 1
    number = line[pos1..pos2]
    pos1 = line.index("%QX.") + 4
    pos2 = line.index(".DigitalOutput") - 1
    name = line[pos1..pos2]
    modules << [number,name]
  end
end

#-- Read through the file again to see if we have already written the OK.
file = File.open(fileName)
file.each do |line|
  if line.include? "OK[" 
    pos1 = line.index("OK[") + 3
    pos2 = line.index("] AT") - 1
    number = line[pos1..pos2]
    exclusionList << number
  end
end

writecount = 0
excludecount = 0
wd = ""


modules.uniq.each do |x|
  unless exclusionList.uniq.include?x[0]
   #puts "will write #{x[0]} -- #{x[1]}" 
    writecount += 1
    wd << "\tOK[#{x[0]}] AT %IX.#{x[1]}.ModuleOk;\n"
  else
    #puts "already in list #{x[0]} "
    excludecount += 1
  end
end
wd << "END_VAR\n"

file = File.read(fileName)
file.gsub!("END_VAR\n","")

file << wd
#puts file
fo = File.open(fileName,"w")
fo.write(file)
fo.close
puts "added #{writecount} modules, found #{excludecount} existing "


