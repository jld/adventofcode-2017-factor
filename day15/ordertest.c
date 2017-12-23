#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int
main(int argc, char** argv)
{
	uint32_t a, x, i;

	if (sscanf(argv[1], "%"SCNu32, &x) != 1) {
		fprintf(stderr, "Not a number; %s\n", argv[1]);
		return 1;
	}
	for (a = x, i = 1; a != 1; i++) {
		a = (uint64_t)a * x % 0x7FFFFFFF;
	}
	printf("%"PRIu32 "\n", i);
	return 0;
}
