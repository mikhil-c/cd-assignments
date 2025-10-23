import syntaxtree.*;
import visitor.*;

public class P3 {
   public static void main(String [] args) {
      try {
         Node root = new MiniJavaParser(System.in).Goal();
         Pass0<Object> v0 = new Pass0<>();  // to get the types of the variables
         root.accept(v0);
         Pass1<Object, Object> v1 = new Pass1<>();  // to get the memory layout of the classes
         root.accept(v1, null);
         Pass2<Object, Object> v2 = new Pass2<>();  // to generate the intermediate code
         v2.symbolTable = v0.symbolTable;
         v2.memLayout = v1.memLayout;
         root.accept(v2, null);
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
}
