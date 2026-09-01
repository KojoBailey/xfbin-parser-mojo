from .traits import AutoParsable

struct NullTerminatingString(AutoParsable & Writable):
	var string: String

	def __init__(out self):
		self.string = ""

	def parse_from_file(mut self, file: FileHandle) raises:
		while True:
			var next_char = chr(Int(file.read_bytes(1)[0]))
			if next_char == '\0':
				break
			self.string += next_char
	
	def write_to(self, mut writer: Some[Writer]):
		writer.write(t"\"{self.string}\"")
