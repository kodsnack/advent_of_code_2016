using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;

namespace AdventOfCode
{
	public partial class Day1 : Form
	{

		List<Point> path = new List<Point>();
		Point firstRepeat;

		public Day1()
		{
			InitializeComponent();
		}

		private void buttonRun_Click(object sender, EventArgs e)
		{
			Point[] directionMovement = new Point[] { new Point(0, -1), new Point(1, 0), new Point(0, 1), new Point(-1, 0) }; // North, East, South, West (Y direction is reversed to follow form coordinates)
			Point position = new Point(0, 0);
			int direction = 0;
			bool repeatFound = false;

			path = new List<Point>();
			path.Add(position);

			foreach (string s in textBoxInput.Text.Split(','))
			{
				if (s.Trim()[0] == 'L')
				{
					direction--;
					if (direction < 0)
					{
						direction += 4;
					}
				}
				else
				{
					direction++;
					if (direction > 3)
					{
						direction -= 4;
					}
				}

				for (int i = 0; i < int.Parse(s.Trim().Substring(1)); i++)
				{
					position.X += directionMovement[direction].X;
					position.Y += directionMovement[direction].Y;
					if (!repeatFound && FindMatch(position))
					{
						firstRepeat = new Point(position.X, position.Y);
						repeatFound = true;
					}
					path.Add(position);
				}
			}

			this.Invalidate();
		}

		private bool FindMatch(Point position)
		{
			foreach (Point p in path)
			{
				if (p.X == position.X && p.Y == position.Y)
				{
					return true;
				}
			}
			return false;
		}

		private void Day1_Paint(object sender, PaintEventArgs e)
		{
			if (path.Count == 0)
				return;

			int centerX = e.ClipRectangle.Width / 2;
			int centerY = e.ClipRectangle.Height / 2;
			int zoomLevel = 2;

			for (int i = 0; i < path.Count - 1; i++)
			{
				e.Graphics.DrawLine(Pens.Black, centerX + path[i].X * zoomLevel, centerY + path[i].Y * zoomLevel, centerX + path[i + 1].X * zoomLevel, centerY + path[i + 1].Y * zoomLevel);
			}

			Point destination = path[path.Count - 1];

			e.Graphics.DrawString(string.Format("Destination {0}  {1}", destination.X, destination.Y), this.Font, Brushes.Red, centerX + destination.X * zoomLevel, centerY + destination.Y * zoomLevel);
			e.Graphics.DrawString(string.Format("First Repeat {0}  {1}", firstRepeat.X, firstRepeat.Y), this.Font, Brushes.Red, centerX + firstRepeat.X * zoomLevel, centerY + firstRepeat.Y * zoomLevel);
		}

	}
}