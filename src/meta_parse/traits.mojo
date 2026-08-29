trait AutoParsable(Defaultable):
	def __init__(out self):
		comptime field_types = reflect[Self].field_types()
		comptime for idx in range(reflect[Self].field_count()):
			comptime type = field_types[idx]
			comptime assert conforms_to(type, Defaultable & Deinitable), "Field is not Defaultable."
			reflect[Self].field_ref[idx](self) = type()

trait HasStaticSize:
	comptime STATIC_SIZE: Int

trait HasDType:
	comptime DTYPE: DType
