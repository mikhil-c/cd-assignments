package visitor;
import java.util.*;

public class CustomType {
   public CustomType() {
        name = new String();
        instanceVar = new HashMap<String, String>();
        method = new HashMap<String, Method>();
        parent = null;
   }
   String name;                         // Name of the custom type
   HashMap<String, String> instanceVar; // Instance variable -> Type
   HashMap<String, Method> method;      // Method -> MethodClass
   String parent;                       // Parent class
}
