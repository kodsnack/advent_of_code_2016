
//http://stackoverflow.com/a/3928241
int permute(char* s, int len){

	//find largest j such that set[j] < set[j+1]; if no such j then done
	int i;
  int j = -1;
  int k;
  int l;
  char c;
  int lastpermutation = 0;
	for (i = 0; i < len; i++)
	{
		if (s[i+1] > s[i])
		{
			j = i;
		}
	}
	if (j == -1)
	{
		lastpermutation = 1;
	}
	if (!lastpermutation)
	{
		for (i = j+1; i < len; i++)
		{
			if (s[i] > s[j])
			{
				l = i;
			}
		}
		c = s[j];
		s[j] = s[l];
		s[l] = c;
		//reverse j+1 to end
		k = (len-1-j)/2; // number of pairs to swap
		for (i = 0; i < k; i++)
		{
			c = s[j+1+i];
			s[j+1+i] = s[len-1-i];
			s[len-1-i] = c;
		}
		//printf("%s\n",s);
	}
  return !lastpermutation;
}
