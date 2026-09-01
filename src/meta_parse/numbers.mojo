from .traits import AutoParsable, HasDType

from std.sys import size_of

struct LittleEndian[dtype: DType](HasDType & ImplicitlyCopyable & AutoParsable & Writable) where dtype.is_integral():
	comptime T = Scalar[Self.dtype]
	comptime DTYPE = Self.dtype
	comptime size = size_of[Self.T]()
	var value: Self.T

	def __init__(out self):
		self.value = Self.T()

	def __init__(out self, bytes: List[Byte]):
		self = Self()
		for idx in range(len(bytes)):
			self.value |= Self.T(bytes[idx]) << Self.T(idx * 8)

	def parse_from_file(mut self, file: FileHandle) raises:
		var byte_list: List[Byte] = file.read_bytes(Self.size)
		self = Self(byte_list^)

	def write_to(self, mut writer: Some[Writer]):
		writer.write(self.value)

struct BigEndian[dtype: DType](HasDType & ImplicitlyCopyable & AutoParsable & Writable) where dtype.is_integral():
	comptime T = Scalar[Self.dtype]
	comptime DTYPE = Self.dtype
	comptime size = size_of[Self.T]()
	var value: Self.T

	def __init__(out self):
		self.value = Self.T()

	def __init__(out self, bytes: List[Byte]):
		self.value = Self.T()
		for idx in range(len(bytes)):
			self.value |= Self.T(bytes[idx]) << Self.T((len(bytes) - 1 - idx) * 8)

	def parse_from_file(mut self, file: FileHandle) raises:
		var byte_list: List[Byte] = file.read_bytes(Self.size)
		self = Self(byte_list^)

	def write_to(self, mut writer: Some[Writer]):
		writer.write(self.value)
