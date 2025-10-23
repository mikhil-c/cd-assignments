import syntaxtree.*;
import visitor.*;

public class P2 {
   public static void main(String [] args) {
      try {
         Node root = new MiniJavaParser(System.in).Goal();
         GJNoArguDepthFirstPass1<String> v1 = new GJNoArguDepthFirstPass1<>();
         root.accept(v1);
         GJDepthFirstPass2<String, Void> v2 = new GJDepthFirstPass2<>();
         v2.symbolTable = v1.symbolTable;
         for (String _type : v1.declaredTypes) {
             if (v2.isLambdaType(_type)) {
                 String type1 = v2.getLambdaInputType(_type);
                 if (!type1.equals("int") && !type1.equals("boolean") && !v2.isValidCustomType(type1)) {
                     throw new ParseException("Symbol not found");
                 }
                 String type2 = v2.getLambdaOutputType(_type);
                 if (!type2.equals("int") && !type2.equals("boolean") && !v2.isValidCustomType(type2)) {
                     throw new ParseException("Symbol not found");
                 }
             }
             else if (!v2.isValidCustomType(_type)) {
                 throw new ParseException("Symbol not found");
             }
         }
         root.accept(v2, null);
         System.out.println("Program type checked successfully");
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
}
