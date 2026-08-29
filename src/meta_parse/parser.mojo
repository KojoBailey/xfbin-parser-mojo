from .traits import HasDType, HasStaticSize
from .numbers import BigEndian, LittleEndian
from .bytes import ByteSequence 

def parse_file_data[T: Defaultable & Movable & Deinitable](file: FileHandle) raises -> T:
	var result = T()

	comptime field_types = reflect[T].field_types()
	comptime field_count = reflect[T].field_count()

	comptime for idx in range(field_count):
		comptime type = field_types[idx]

		comptime if reflect[type].base_name() == "BigEndian":
			comptime assert(conforms_to(type, HasDType & Movable & Deinitable))
			comptime assert(type.DTYPE.is_integral())
			reflect[T].field_ref[idx](result) = \
				rebind_var[type](BigEndian[type.DTYPE].parse_from_file(file))

		elif type == LittleEndian[DType.uint32]:
			comptime assert(conforms_to(type, Movable & Deinitable))
			reflect[T].field_ref[idx](result) = rebind_var[type](LittleEndian[DType.uint32].parse_from_file(file))

		elif reflect[type].base_name() == "ByteSequence":
			comptime assert(conforms_to(type, HasStaticSize & Movable & Deinitable))
			reflect[T].field_ref[idx](result) = \
				rebind_var[type](ByteSequence[type.STATIC_SIZE].parse_from_file(file))

		else:
			raise Error("[parse_data error] Unknown Type:", reflect[type].name())
	
	return result^
