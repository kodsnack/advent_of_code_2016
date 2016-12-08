
public class Navigator
{
	private final int[] turns = new int[]{0, 0, 0, 0};
	private int direction = 0;
	
	public static void main(String[] args)
	{
		Navigator n = new Navigator();
		
		for(String s : args)
		{
			s = s.replace(",", "");
			n.walk(s.charAt(0), s.substring(1));
		}
	
		final int dist = n.summarize();
		System.out.println(dist);
	}
	
	public void walk(char dir, String blocks)
	{
		final int blockCount = Integer.parseInt(blocks);
		if(dir == 'L')
			direction--;
		else if(dir == 'R')
			direction++;
		direction %= 4;
		
		if(direction < 0)
			direction += 4;
		
		turns[direction]+= blockCount;
	}
	
	public int summarize()
	{
		final int y = Math.abs(turns[0] - turns[2]); 
		final int x = Math.abs(turns[1] - turns[3]);
		return x + y;
	}
}
