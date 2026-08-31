from .traits import AutoParsable, HasStaticSize

from std.memory import unsafe_memcpy

@fieldwise_init
struct Bytes[SIZE: Int](Copyable & HasStaticSize & AutoParsable & Writable):
	comptime STATIC_SIZE = Self.SIZE
	var bytes: Array[UInt8, Self.SIZE]

	def __init__(out self):
		self.bytes = Array[UInt8, Self.SIZE](uninitialized = True)

	def __init__(out self, byte_list: List[UInt8]):
		self.bytes = Array[UInt8, Self.SIZE]()
		unsafe_memcpy(
			dest = self.bytes.unsafe_ptr(),
			src = byte_list.unsafe_ptr(),
			count = Self.SIZE
		)

	@staticmethod
	def parse_from_file(file: FileHandle) raises -> Self:
		var byte_list: List[UInt8] = file.read_bytes(Self.SIZE) # TODO: Find way to get Array instead of List.
		return Self(byte_list^)
	
	def to_hex_string(self, *, delimiter: String = "") -> String:
		var string_bytes = List[String]()
		for byte in self.bytes:
			var string_byte: String = hex(byte, prefix = "").upper()
			if string_byte.byte_length() == 1:
				string_byte = String(t"0{string_byte}")
			string_bytes.append(string_byte)
		return " ".join(string_bytes)

	def to_string(self) -> String:
		var result: String = ""
		for byte in self.bytes:
			result += chr(Int(byte))
		return result

	def write_to(self, mut writer: Some[Writer]):
		writer.write(t"{self.to_hex_string()} / \"{self.to_string()}\"")
