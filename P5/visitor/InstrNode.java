package visitor;
import java.util.*;

class InstrNode {
    InstrNode() {
        def = new HashSet<>();
        use = new HashSet<>();
        targetLabel = null;

        in = new HashSet<>();
        out = new HashSet<>();
    }
    public HashSet<String> def;
    public HashSet<String> use;
    public String targetLabel; // stores the jump target label
                               
    public HashSet<String> in;
    public HashSet<String> out;
}
