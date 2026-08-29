from .traits import HasDType

from std.sys import size_of

@fieldwise_init
struct LittleEndian[dtype: DType](HasDType & ImplicitlyCopyable & Writable) where dtype.is_integral():
	comptime T = Scalar[Self.dtype]
	comptime DTYPE = Self.dtype
	comptime size = size_of[Self.T]()
	var value: Self.T

	def __init__(out self):
		self.value = 0

	def __init__(out self, bytes: List[Byte]):
		self.value = 0
		for idx in range(len(bytes)):
			self.value |= Self.T(bytes[idx]) << Self.T(idx * 8)

	@staticmethod
	def parse_from_file(file: FileHandle) raises -> Self:
		var byte_list: List[Byte] = file.read_bytes(Self.size)
		return Self(byte_list^)

	def write_to(self, mut writer: Some[Writer]):
		writer.write(self.value)

@fieldwise_init
struct BigEndian[dtype: DType](HasDType & ImplicitlyCopyable & Defaultable & Writable) where dtype.is_integral():
	comptime T = Scalar[Self.dtype]
	comptime DTYPE = Self.dtype
	comptime size = size_of[Self.T]()
	var value: Self.T

	def __init__(out self):
		self.value = 0

	def __init__(out self, bytes: List[Byte]):
		self.value = 0
		for idx in range(len(bytes)):
			self.value |= Self.T(bytes[idx]) << Self.T((len(bytes) - 1 - idx) * 8)

	@staticmethod
	def parse_from_file(file: FileHandle) raises -> Self:
		var byte_list: List[Byte] = file.read_bytes(Self.size)
		return Self(byte_list^)

	def write_to(self, mut writer: Some[Writer]):
		writer.write(self.value)
