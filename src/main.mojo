from std.sys import argv

from pretty_print import pretty_print
from meta_parse import AutoParsable, BigEndian, Bytes, NullTerminatingString, DependentArray

comptime BigI16 = BigEndian[DType.int16]
comptime BigU16 = BigEndian[DType.uint16]
comptime BigU32 = BigEndian[DType.uint32]

struct XfbinChunkMap(AutoParsable & Writable):
	var chunk_type_index: BigU32
	var file_path_index: BigU32
	var chunk_name_index: BigU32

struct XfbinFlagsLayout(AutoParsable):
	var is_encrypted: BigI16
	var language_id: Bytes[2]
	var unk_flag1: BigI16
	var unk_flag2: BigI16

struct XfbinIndexLayout(AutoParsable):
	var size: BigU32
	var map_index: BigU32
	var version: BigU16
	var unk: BigU16
	var chunk_type_count: BigU32
	var chunk_type_size: BigU32
	var file_path_count: BigU32
	var file_path_size: BigU32
	var chunk_name_count: BigU32
	var chunk_name_size: BigU32
	var chunk_map_count: BigU32
	var chunk_map_size: BigU32
	var chunk_map_indices_count: BigU32
	var extra_map_indices_count: BigU32
	var chunk_types: DependentArray[NullTerminatingString]
	var file_paths: DependentArray[NullTerminatingString]
	var chunk_names: DependentArray[NullTerminatingString]
	var chunk_maps: DependentArray[XfbinChunkMap]

	def perform_intermediate_step[before: StaticString](mut self, file: FileHandle) raises:
		comptime if before == "chunk_types":
			self.chunk_types.count = Int(self.chunk_type_count.value)
		elif before == "file_paths":
			self.file_paths.count = Int(self.file_path_count.value)
		elif before == "chunk_names":
			self.chunk_names.count = Int(self.chunk_name_count.value)
		elif before == "chunk_maps":
			var current_pos = file.seek(0, whence = 1)
			_ = file.seek(Int(current_pos + 4 - current_pos % 4))
			self.chunk_maps.count = Int(self.chunk_map_count.value)
	
struct XfbinLayout(AutoParsable):
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

		var xfbinBinaryData = XfbinLayout()
		xfbinBinaryData.parse_from_file(file^)
		pretty_print(xfbinBinaryData)

		file.close()

	except e:
		print("Error:", e)
