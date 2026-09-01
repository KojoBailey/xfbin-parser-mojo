from .parser import parse_file_data
from .numbers import BigEndian, LittleEndian
from .bytes import Bytes
from .dependent_array import DependentArray

# TODO: These 2 can be removed.
trait HasStaticSize:
	comptime STATIC_SIZE: Int

trait HasDType:
	comptime DTYPE: DType

trait Dependent:
	pass

trait AutoParsable(Copyable & Deinitable):
	def __init__(out self):
		comptime field_types = reflect[Self].field_types()
		comptime for idx in range(reflect[Self].field_count()):
			comptime Type = field_types[idx]
			comptime assert(conforms_to(Type, AutoParsable))
			reflect[Self].field_ref[idx](self) = Type()
	
	def fill_in_dependents(mut self) raises:
		pass

	def parse_from_file(mut self, file: FileHandle) raises:
		comptime field_types = reflect[Self].field_types()
		comptime field_count = reflect[Self].field_count()

		comptime for idx in range(field_count):
			comptime T = field_types[idx]
			comptime assert(conforms_to(T, AutoParsable))
			comptime if not conforms_to(T, Dependent):
				reflect[Self].field_ref[idx](self).parse_from_file(file)

		self.fill_in_dependents()

		comptime for idx in range(field_count):
			comptime T = field_types[idx]
			comptime assert(conforms_to(T, AutoParsable))
			comptime if conforms_to(T, Dependent):
				reflect[Self].field_ref[idx](self).parse_from_file(file)
