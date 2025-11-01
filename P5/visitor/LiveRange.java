package visitor;
import java.util.*;

public class LiveRange {
    LiveRange() {
        min = Integer.MAX_VALUE;
        max = Integer.MIN_VALUE;

        temp = new String();
        reg = new String();
        isSpilled = false;
    }
    public int min;
    public int max;

    public String temp;
    public String reg; // allocated register if not spilled
    public boolean isSpilled;
    public int loc;    // spilled location on the stack 

    public boolean isArgu(int N) {
        int i = Integer.parseInt(temp.replaceAll("TEMP ", ""));
        return i < N;
    }
}
