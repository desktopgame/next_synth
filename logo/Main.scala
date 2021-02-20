import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.io.File;
import java.awt.Graphics2D
import java.awt.Graphics
import java.awt.Color

object Main extends App {
    val imgWidth = 1024;
    val imgHeight = 1024;
    var bufImage = new BufferedImage(imgWidth, imgHeight, BufferedImage.TYPE_INT_RGB);
    var g = bufImage.getGraphics().asInstanceOf[Graphics2D];
    var colorIndex = 0;
    var colorTable = List(Color.white, Color.black, Color.white, Color.black, Color.white, Color.white, Color.black, Color.white, Color.black, Color.white, Color.black, Color.white).reverse;
    val rows = 12;
    val columns = 4;
    val keyWidth = 200;
    for(i <- 0 to rows) {
        val width = imgWidth;
        val height = imgHeight / rows;
        g.setColor(colorTable(colorIndex % 12));
        g.fillRect(0, i * height, width, height);
        colorIndex+=1
    }
    for(i <- 0 to rows) {
        val width = imgWidth;
        val height = imgHeight / rows;
        g.setColor(Color.gray);
        g.fillRect(0, i * height, width, 3);
    }
    g.setColor(Color.red);
    g.fillRect(keyWidth + ((imgWidth - keyWidth) / columns), 5 * (imgHeight / rows), 100, (imgHeight / rows))
    g.fillRect(keyWidth, 7 * (imgHeight / rows), 100, (imgHeight / rows))
    g.fillRect(keyWidth + (((imgWidth - keyWidth) / columns) * 2), 5 * (imgHeight / rows), 100, (imgHeight / rows))
    
    for(i <- 0 to columns) {
        val x = i * ((imgWidth - keyWidth) / columns);
        g.setColor(Color.green);
        g.fillRect(x + keyWidth, 0, 3, imgHeight);
    }
    ImageIO.write(bufImage, "PNG", new File("logo.png"));
}