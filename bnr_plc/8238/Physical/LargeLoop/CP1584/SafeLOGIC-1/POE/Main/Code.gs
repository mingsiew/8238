[LIT]
17
12	101	11	105	11
30	91	50	106	50
31	65	50	79	50
32	65	36	65	50
33	135	15	144	15
34	144	36	65	36
47	136	50	143	50
48	143	50	143	43
49	143	50	152	50
50	143	43	151	43
52	144	15	144	36
53	179	15	186	15
54	144	15	155	15
55	51	15	61	15
56	61	15	105	15
57	61	20	69	20
58	61	15	61	20

[TET]
10
11	89	10	101	12	4	5	SAFETRUE
13	19	14	51	16	4	5	SM2_SafeTwoChannelInput0102
14	94	45	106	47	4	5	SAFETRUE
35	47	53	79	55	4	5	SM2_SafeTwoChannelInput0304
36	175	42	186	44	4	3	BOOL002
37	90	26	105	28	4	5	Reset_Zone_0
38	91	62	106	64	4	5	Reset_Zone_1
45	69	19	95	21	4	3	SM3_SafeDigitalOutput01
46	152	49	178	51	4	3	SM3_SafeDigitalOutput02
51	186	14	210	16	4	3	SM3_ReleaseOutput01

[FBS]
5
9	107	7	133	31	0	SF_EmergencyStop_V1_00	SF_EmergencyStop_V1_00_1
24	108	42	134	66	0	SF_EmergencyStop_V1_00	SF_EmergencyStop_V1_00_2
29	81	46	89	58	1	AND_S	
41	157	11	177	19	1	SAFEBOOL_TO_BOOL	
44	153	39	173	47	1	SAFEBOOL_TO_BOOL	

[FPT]
25
0	107	10	117	12	Activate	0	128	0	BOOL
1	107	14	119	16	S_EStopIn	0	128	0	SAFEBOOL
2	107	18	121	20	S_StartReset	0	128	0	SAFEBOOL
3	107	22	121	24	S_AutoReset	0	128	0	SAFEBOOL
4	107	26	115	28	Reset	0	128	0	BOOL
5	126	10	133	12	Ready	1	0	128	BOOL
6	121	14	133	16	S_EStopOut	1	0	128	SAFEBOOL
7	127	18	133	20	Error	1	0	128	BOOL
8	123	22	133	24	DiagCode	1	0	128	WORD
15	108	45	118	47	Activate	0	128	0	BOOL
16	108	49	120	51	S_EStopIn	0	128	0	SAFEBOOL
17	108	53	122	55	S_StartReset	0	128	0	SAFEBOOL
18	108	57	122	59	S_AutoReset	0	128	0	SAFEBOOL
19	108	62	116	64	Reset	0	128	0	BOOL
20	127	45	134	47	Ready	1	0	128	BOOL
21	122	49	134	51	S_EStopOut	1	0	128	SAFEBOOL
22	128	53	134	55	Error	1	0	128	BOOL
23	124	57	134	59	DiagCode	1	0	128	WORD
26	81	49	83	51		0	1665	0	ANY_SAFEBIT
27	81	53	83	55		0	1665	0	ANY_SAFEBIT
28	88	49	89	51		1	0	641	ANY_SAFEBIT
39	157	14	159	16		0	640	0	SAFEBOOL
40	176	14	177	16		1	0	640	BOOL
42	153	42	155	44		0	640	0	SAFEBOOL
43	172	42	173	44		1	0	640	BOOL

[KOT]
0

[VER]
0

