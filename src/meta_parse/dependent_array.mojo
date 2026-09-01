from .traits import AutoParsable, Dependent

struct DependentArray[T: AutoParsable & Writable](AutoParsable & Dependent & Writable):
	var count: Int
	var data: List[Self.T]

	def __init__(out self):
		self.count = Int()
		self.data = List[Self.T]()

	def parse_from_file(mut self, file: FileHandle) raises:
		for idx in range(self.count):
			self.data.append(Self.T())
			self.data[idx].parse_from_file(file)
	
	def write_to(self, mut writer: Some[Writer]):
		writer.write(t"[size = {self.count}\n")
		for item in self.data:
			writer.write(t"\t{item},\n")
		writer.write("]")
