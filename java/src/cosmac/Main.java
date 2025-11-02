package cosmac;

public class Main {
	public static void main(String[] args) throws Exception {
		//  Note: 
		// Running Gen1802SimuJavaCode().run() creates the simulator source Java code,
		//  so obviously on the *same* run that code has not yet been compiled and thus
		//  will not execute and some old stale class file will be executed. So if you
		//  make mods to the simulation generation you need to set following false, run
		//  this code, the set it to true and run this code again.
		if (true)
			new RunTests().run();
		else
			new Gen1802SimuJavaCode().run();
	}

}
