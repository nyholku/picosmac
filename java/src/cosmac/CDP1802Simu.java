package cosmac;

public class CDP1802Simu extends CDP1802Execute {
	CDP1802Simu() {
		
	}
	public CDP1802Simu(int ramsize) {
		for (int i = 0; i < ramsize; i++)
			M[i] = 0;
	}
}
