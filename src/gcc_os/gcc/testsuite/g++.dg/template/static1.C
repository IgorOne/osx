template <typename T> struct A
{
  static const int t[1][1]={{0}}; // { dg-error "in-class" }
};
