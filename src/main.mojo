from std.sys import argv

from pretty_print import pretty_print
from meta_parse import parse_file_data, BigEndian, ByteSequence 

@fieldwise_init
struct XfbinBinaryLayout(Copyable & Defaultable):
	var file_signature: ByteSequence[4]
	var version: BigEndian[DType.uint32]
	var is_encrypted: BigEndian[DType.int16]
	var language_id: ByteSequence[2]
	var unk_flag1: BigEndian[DType.int16]
	var unk_flag2: BigEndian[DType.int16]
	var meta_size: BigEndian[DType.uint32]
	var meta_map_index: BigEndian[DType.uint32]
	var meta_version: BigEndian[DType.uint16]

	def __init__(out self):
		self.file_signature = ByteSequence[4]()
		self.version = BigEndian[DType.uint32]()
		self.is_encrypted = BigEndian[DType.int16]()
		self.language_id = ByteSequence[2]()
		self.unk_flag1 = BigEndian[DType.int16]()
		self.unk_flag2 = BigEndian[DType.int16]()
		self.meta_size = BigEndian[DType.uint32]()
		self.meta_map_index = BigEndian[DType.uint32]()
		self.meta_version = BigEndian[DType.uint16]()

def main():
	try:
		var args = argv()
		if len(args) != 2:
			raise Error("Insufficient args.")

		var file_path = args[1]
		var file = open(file_path, "r")

		var xfbinBinaryData = parse_file_data[XfbinBinaryLayout](file^)
		pretty_print(xfbinBinaryData)

		file.close()

	except e:
		print("Error:", e)
