import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import javax.imageio.ImageIO;

public class imgToArray {
	String path = "Bomber.png";
	String outpath = "Bomber.txt";

	public imgToArray() {
		this(null);
	}

	public imgToArray(String p) {
		if(p!=null) {
			path = p;
			outpath = new String(path+".txt");
		}
		BufferedImage image = null;
		FileWriter out = null;
		File F = new File(path);
		try {
			out = new FileWriter(outpath);
			image = ImageIO.read(F);
		} catch (IOException e) {
			e.printStackTrace();
		}
		int X = image.getWidth();
		int Y = image.getHeight();
		for (int j = 0; j < Y; j++) {
			try {
				for (int i = 0; i < X; i++) {
					int col = image.getRGB(i, j);
					if (col == 0xffffffff)
						out.write(0xf);
					else if (col == 0xFFED1C24)
						out.write(0x4);
					else if (col == 0xFFFFF200)
						out.write(0xe);
					else if (col == 0xFF3F48CC)
						out.write(0x1);
					else if (col == 0xFF000000)
						out.write(0x0);
				}
			} catch (IOException e) {
				e.printStackTrace();
			}

		}
		System.out.println("pixel count: " + X * Y);
		try {
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static void main(String args[]) {
		if (args.length > 0)
			new imgToArray(args[0]);
		else
			new imgToArray();
	}
}
