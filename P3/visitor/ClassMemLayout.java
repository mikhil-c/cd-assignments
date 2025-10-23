package visitor;
import java.util.*;

class ClassMemLayout {
    ClassMemLayout() {
        name = new String();
        vtable = new HashMap<>();
        fields = new HashMap<>();
        parent = null;
    }
    public String name;                      // class name
    public HashMap<String, Integer> fields;  // fields -> index
    public HashMap<String, Integer> vtable;  // function -> index
    public String parent;                    // parent class
}
