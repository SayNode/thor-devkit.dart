///ABI v1 style paramter wrapper. This can be further process into JSON. */
class V1ParamWrapper {
  int index; // The parameter position in the tuple.
  String name; // The name of the parameter, can be "".
  String canonicalType; // The solidity type name.
  Object value; // The real value of the parameter, String/BigInterger, etc.

  V1ParamWrapper(this.index, this.name, this.canonicalType, this.value);
}
