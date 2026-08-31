from std.sys import argv

from pretty_print import pretty_print
from meta_parse import parse_file_data, AutoParsable, BigEndian, Bytes 

comptime BigI16 = BigEndian[DType.int16]
comptime BigU16 = BigEndian[DType.uint16]
comptime BigU32 = BigEndian[DType.uint32]

struct XfbinFlagsLayout(Copyable & AutoParsable):
	var is_encrypted: BigI16
	var language_id: Bytes[2]
	var unk_flag1: BigI16
	var unk_flag2: BigI16

struct XfbinIndexLayout(Copyable & AutoParsable):
	var size: BigU32
	var map_index: BigU32
	var version: BigU16
	var unk: BigU16
	var chunk_type_count: BigU32
	var chunk_type_size: BigU32
	var file_size_count: BigU32
	var file_size_size: BigU32
	var chunk_name_size: BigU32
	var chunk_name_count: BigU32
	var chunk_map_size: BigU32
	var chunk_map_count: BigU32
	var chunk_map_indices_count: BigU32
	var extra_map_indices_count: BigU32

struct XfbinLayout(Copyable & AutoParsable):
	var file_signature: Bytes[4]
	var version: BigU32
	var flags: XfbinFlagsLayout
	var index: XfbinIndexLayout

def main():
	try:
		var args = argv()
		if len(args) != 2:
			raise Error("Insufficient args.")

		var file_path = args[1]
		var file = open(file_path, "r")

		var xfbinBinaryData = parse_file_data[XfbinLayout](file^)
		pretty_print(xfbinBinaryData)

		file.close()

	except e:
		print("Error:", e)
