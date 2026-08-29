def pretty_print[T: AnyType](ref object: T):
	comptime field_count = reflect[T].field_count()
	comptime field_types = reflect[T].field_types()
	comptime field_names = reflect[T].field_names()

	comptime for idx in range(field_count):
		comptime type = field_types[idx]
		comptime type_string = reflect[type].base_name()
		comptime name = field_names[idx]
		comptime if conforms_to(type, Copyable & Deinitable & Writable):
			var value = reflect[T].field_ref[idx](object).copy()
			print(t"{name}: {type_string} = {value}")
		else:
			print(t"{name}: {type_string} is not Writable")
