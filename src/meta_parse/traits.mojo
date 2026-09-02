trait AutoParsable(Copyable & Deinitable):
	def __init__(out self):
		comptime field_types = reflect[Self].field_types()
		comptime for idx in range(reflect[Self].field_count()):
			comptime Type = field_types[idx]
			comptime assert(conforms_to(Type, AutoParsable))
			reflect[Self].field_ref[idx](self) = Type()
	
	def perform_intermediate_step[before: StaticString](mut self, file: FileHandle) raises:
		pass

	def parse_from_file(mut self, file: FileHandle) raises:
		comptime field_types = reflect[Self].field_types()
		comptime field_names = reflect[Self].field_names()
		comptime field_count = reflect[Self].field_count()

		comptime for idx in range(field_count):
			comptime T = field_types[idx]
			comptime field_name = field_names[idx]
			comptime assert(conforms_to(T, AutoParsable))

			self.perform_intermediate_step[field_name](file)

			reflect[Self].field_ref[idx](self).parse_from_file(file)
