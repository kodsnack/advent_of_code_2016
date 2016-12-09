namespace AdventOfCode
{
	partial class MainForm
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.buttonDay1 = new System.Windows.Forms.Button();
			this.SuspendLayout();
			// 
			// buttonDay1
			// 
			this.buttonDay1.Location = new System.Drawing.Point(12, 12);
			this.buttonDay1.Name = "buttonDay1";
			this.buttonDay1.Size = new System.Drawing.Size(75, 23);
			this.buttonDay1.TabIndex = 0;
			this.buttonDay1.Text = "Day 1";
			this.buttonDay1.UseVisualStyleBackColor = true;
			this.buttonDay1.Click += new System.EventHandler(this.buttonDay1_Click);
			// 
			// MainForm
			// 
			this.ClientSize = new System.Drawing.Size(542, 344);
			this.Controls.Add(this.buttonDay1);
			this.Name = "MainForm";
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.Button buttonDay1;
	}
}

