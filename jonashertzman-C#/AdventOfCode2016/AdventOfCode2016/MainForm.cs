using System;
using System.Windows.Forms;

namespace AdventOfCode
{
	public partial class MainForm : Form
	{

		public MainForm()
		{
			InitializeComponent();
		}

		private void buttonDay1_Click(object sender, EventArgs e)
		{
			Day1 dialog = new Day1();
			dialog.ShowDialog();
		}

		private void buttonDay2_Click(object sender, EventArgs e)
		{
			Day2.Run();			
		}

	}
}
