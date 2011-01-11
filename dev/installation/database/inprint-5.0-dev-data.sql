--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: ad_advertisers_serialnum_seq; Type: SEQUENCE SET; Schema: public; Owner: inprint
--

SELECT pg_catalog.setval('ad_advertisers_serialnum_seq', 1, false);


--
-- Name: ad_requests_serialnum_seq; Type: SEQUENCE SET; Schema: public; Owner: inprint
--

SELECT pg_catalog.setval('ad_requests_serialnum_seq', 1, false);


--
-- Name: fascicles_requests_serialnum_seq; Type: SEQUENCE SET; Schema: public; Owner: inprint
--

SELECT pg_catalog.setval('fascicles_requests_serialnum_seq', 1, false);


--
-- Data for Name: ad_advertisers; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: ad_index; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: ad_modules; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: ad_pages; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: ad_places; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: ad_requests; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: branches; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO members VALUES ('39d40812-fc54-4342-9b98-e1c1f4222d22', 'root', '4813494d137e1631bba301d5acab6e7bb7aa74ce1185d456565ef51d737677b2', '2011-01-07 01:05:35.75+03', '2011-01-07 01:05:35.75+03');


--
-- Data for Name: cache_access; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO cache_access VALUES ('domain', '00000000000000000000000000000000', '00000000-0000-0000-0000-000000000000', '39d40812-fc54-4342-9b98-e1c1f4222d22', '{domain.configuration.view,domain.departments.manage,domain.editions.manage,domain.employees.manage,domain.exchange.manage,domain.login.allowed,domain.readiness.manage,domain.roles.manage}');
INSERT INTO cache_access VALUES ('editions', '00000000000000000000000000000000', '00000000-0000-0000-0000-000000000000', '39d40812-fc54-4342-9b98-e1c1f4222d22', '{editions.documents.work,editions.calendar.view,editions.layouts.view,editions.documents.assign,editions.calendar.manage,editions.layouts.manage}');
INSERT INTO cache_access VALUES ('catalog', '00000000000000000000000000000000', '00000000-0000-0000-0000-000000000000', '39d40812-fc54-4342-9b98-e1c1f4222d22', '{catalog.files.work:member,catalog.documents.view:member,catalog.files.delete:member,catalog.documents.delete:member,catalog.documents.move:member,catalog.files.add:member,catalog.documents.create:member,catalog.documents.assign:member,catalog.documents.briefcase:member,catalog.documents.discuss:member,catalog.documents.recover:member,catalog.documents.update:member,catalog.documents.capture:member,catalog.documents.transfer:member}');
INSERT INTO cache_access VALUES ('catalog', '00000000000000000000000000000000.420a1f206c121014a920ade64561c3cc', '420a1f20-6c12-1014-a920-ade64561c3cc', '39d40812-fc54-4342-9b98-e1c1f4222d22', '{catalog.files.work:member,catalog.documents.view:member,catalog.files.delete:member,catalog.documents.delete:member,catalog.documents.move:member,catalog.files.add:member,catalog.documents.create:member,catalog.documents.assign:member,catalog.documents.briefcase:member,catalog.documents.discuss:member,catalog.documents.recover:member,catalog.documents.update:member,catalog.documents.capture:member,catalog.documents.transfer:member}');
INSERT INTO cache_access VALUES ('editions', '00000000000000000000000000000000.4339817b6c121014a920ade64561c3cc', '4339817b-6c12-1014-a920-ade64561c3cc', '39d40812-fc54-4342-9b98-e1c1f4222d22', '{editions.documents.work,editions.calendar.view,editions.layouts.view,editions.documents.assign,editions.calendar.manage,editions.layouts.manage}');


--
-- Data for Name: cache_visibility; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO cache_visibility VALUES ('editions', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions.calendar.manage', '0eecba74-ca40-4b8d-a710-03382483b0f4', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('editions', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions.calendar.view', '76323a53-1c22-4ff4-8f19-5e43d5aa0bd4', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('editions', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions.layouts.manage', 'ed9580be-1f36-45d1-9b60-36a2a85e5589', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('editions', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions.layouts.view', '2d34dbb9-db14-4fe8-a2c8-9a57e328b0b5', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('editions', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions.documents.work', '133743df-52ab-4277-b320-3ede5222cb12', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('editions', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions.documents.assign', '52dc7f72-2057-43c0-831d-55e458d84f39', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('catalog', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog.documents.view:member', 'ac0a0d95-c4d3-4bd7-93c3-cc0fc230936f', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('catalog', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog.documents.create:member', 'ee992171-d275-4d24-8def-7ff02adec408', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('catalog', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog.documents.assign:member', '6033984a-a762-4392-b086-a8d2cdac4221', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('catalog', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog.documents.delete:member', '3040f8e1-051c-4876-8e8e-0ca4910e7e45', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('catalog', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog.documents.recover:member', 'beba3e8d-86e5-4e98-b3eb-368da28dba5f', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('catalog', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog.documents.update:member', '5b27108a-2108-4846-a0a8-3c369f873590', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('catalog', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog.files.work:member', 'bff78ebf-2cba-466e-9e3c-89f13a0882fc', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('catalog', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog.files.add:member', 'f4ad42ed-b46b-4b4e-859f-1b69b918a64a', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('catalog', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog.files.delete:member', 'fe9cd446-2f4b-4844-9b91-5092c0cabece', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('catalog', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog.documents.capture:member', 'd782679e-3f0a-4499-bda6-8c2600a3e761', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('catalog', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog.documents.transfer:member', 'b946bd84-93fc-4a70-b325-d23c2804b2e9', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('catalog', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog.documents.move:member', 'b7adafe9-2d5b-44f3-aa87-681fd48466fa', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('catalog', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog.documents.briefcase:member', '6d590a90-58a1-447f-b5ad-e3c62f80a2ef', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');
INSERT INTO cache_visibility VALUES ('catalog', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog.documents.discuss:member', '6d590a90-58a1-447f-b5ad-b0582b64571a', '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}');


--
-- Data for Name: catalog; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO catalog VALUES ('00000000-0000-0000-0000-000000000000', '00000000000000000000000000000000', 'Publishing House', 'Publishing House', 'Publishing House', 'ou', '{default}', '2011-01-07 01:05:35.733+03', '2011-01-07 01:05:35.733+03');
INSERT INTO catalog VALUES ('420a1f20-6c12-1014-a920-ade64561c3cc', '00000000000000000000000000000000.420a1f206c121014a920ade64561c3cc', '1', '1', '1', 'default', '{}', '2011-01-07 01:32:47.165+03', '2011-01-07 01:32:47.165+03');


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: editions; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO editions VALUES ('00000000-0000-0000-0000-000000000000', '00000000000000000000000000000000', 'All editions', 'All editions', 'All editions', '2011-01-07 01:05:35.743+03', '2011-01-07 01:05:35.743+03');
INSERT INTO editions VALUES ('4339817b-6c12-1014-a920-ade64561c3cc', '00000000000000000000000000000000.4339817b6c121014a920ade64561c3cc', '1', '1', '1', '2011-01-07 01:32:54.775+03', '2011-01-07 01:32:54.775+03');


--
-- Data for Name: editions_options; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: fascicles; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO fascicles VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', 'Briefcase', 'Briefcase', 'Briefcase', NULL, '00000000-0000-0000-0000-000000000000', '2011-01-07 01:05:35.747+03', '2011-01-07 01:05:35.747+03', '2011-01-07 01:05:35.747+03', '2011-01-07 01:05:35.747+03');
INSERT INTO fascicles VALUES ('99999999-9999-9999-9999-999999999999', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', 'Recycle bin', 'Recycle bin', 'Recycle bin', NULL, '00000000-0000-0000-0000-000000000000', '2011-01-07 01:05:35.75+03', '2011-01-07 01:05:35.75+03', '2011-01-07 01:05:35.75+03', '2011-01-07 01:05:35.75+03');


--
-- Data for Name: fascicles_indx_headlines; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO fascicles_indx_headlines VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', true, '--', '--', '--', '2011-01-07 01:05:35.759+03', '2011-01-07 01:05:35.759+03');


--
-- Data for Name: fascicles_indx_rubrics; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO fascicles_indx_rubrics VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', true, '--', '--', '--', '2011-01-07 01:05:35.762+03', '2011-01-07 01:05:35.762+03');


--
-- Data for Name: fascicles_tmpl_pages; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: fascicles_pages; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: fascicles_map_documents; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: fascicles_tmpl_modules; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: fascicles_tmpl_places; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: fascicles_modules; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: fascicles_map_modules; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: fascicles_map_requests; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: fascicles_options; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: fascicles_requests; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: fascicles_tmpl_index; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: history; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: indx_headlines; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO indx_headlines VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '--', '--', '--', true, '2011-01-07 01:05:35.755+03', '2011-01-07 01:05:35.755+03');


--
-- Data for Name: indx_rubrics; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO indx_rubrics VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '--', '--', '--', true, '2011-01-07 01:05:35.757+03', '2011-01-07 01:05:35.757+03');


--
-- Data for Name: indx_tags; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO indx_tags VALUES ('00000000-0000-0000-0000-000000000000', '--', '--', '--', '2011-01-07 01:05:35.754+03', '2011-01-07 01:05:35.754+03');


--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO logs VALUES ('af562b58-02d0-4ea4-b0d1-ae76c82cb759', '00000000-0000-0000-0000-000000000000', 'Unknown', 'Unknown', 'Unknown', '00000000-0000-0000-0000-000000000000', 'system', 'The user with login %1 was logged into the program', 'login', '{"root"}', '2011-01-07 01:08:12.813+03');


--
-- Data for Name: map_member_to_catalog; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO map_member_to_catalog VALUES ('c293a89e-e044-41e6-a267-dbefba39a450', '39d40812-fc54-4342-9b98-e1c1f4222d22', '00000000-0000-0000-0000-000000000000');


--
-- Data for Name: map_member_to_rule; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO map_member_to_rule VALUES ('2f96242b-5c76-4418-afcb-4b2e75f95b48', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '6406ad57-c889-47c5-acc6-0cd552e9cf5e');
INSERT INTO map_member_to_rule VALUES ('8c0bf266-a93d-4a46-930a-0c6ec558fa75', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '32e0bb97-2bae-4ce8-865e-cdf0edb3fd93');
INSERT INTO map_member_to_rule VALUES ('10f41d8a-46a5-4f2d-824d-321243b92bc0', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '086993e0-56aa-441f-8eaf-437c1c5c9691');
INSERT INTO map_member_to_rule VALUES ('1c6d1f3d-c4ad-4a2a-95d8-f0bb4637cc31', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', 'e55d9548-36fe-4e51-bec2-663235b5383e');
INSERT INTO map_member_to_rule VALUES ('b1421263-33cb-4b0a-a19c-c8706ef4db29', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '2a3cae11-23ea-41c3-bdb8-d3dfdc0d486a');
INSERT INTO map_member_to_rule VALUES ('1697b7ce-aa5b-4719-9acf-687f4d6ebb1e', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '2fde426b-ed30-4376-9a7b-25278e8f104a');
INSERT INTO map_member_to_rule VALUES ('2b50ec94-3936-4e2b-801a-129724c2bbe4', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', 'aa4e74ad-116e-4bb2-a910-899c4f288f40');
INSERT INTO map_member_to_rule VALUES ('72b48332-3ac3-4bed-bb51-34636d8eb47b', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '9d057494-c2c6-41f5-9276-74b33b55c6e3');
INSERT INTO map_member_to_rule VALUES ('7f8d0427-0ddc-46df-ae05-45cff1592a31', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', '0eecba74-ca40-4b8d-a710-03382483b0f4');
INSERT INTO map_member_to_rule VALUES ('2be8ca5e-1d1d-4337-8daf-853e07ec0d16', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', '76323a53-1c22-4ff4-8f19-5e43d5aa0bd4');
INSERT INTO map_member_to_rule VALUES ('e6ea08e6-6b70-4207-a32e-2a00082bd603', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', 'ed9580be-1f36-45d1-9b60-36a2a85e5589');
INSERT INTO map_member_to_rule VALUES ('1ef9bea1-20b8-48f4-a1f7-938bc64e8232', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', '2d34dbb9-db14-4fe8-a2c8-9a57e328b0b5');
INSERT INTO map_member_to_rule VALUES ('bc4dc623-ad04-4607-8aca-fec1e5e048d4', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', '133743df-52ab-4277-b320-3ede5222cb12');
INSERT INTO map_member_to_rule VALUES ('cf119771-88f6-4340-b90d-dc2dec5e972f', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', '52dc7f72-2057-43c0-831d-55e458d84f39');
INSERT INTO map_member_to_rule VALUES ('263dc904-04a9-4dde-b45f-fc42e53d2633', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'ac0a0d95-c4d3-4bd7-93c3-cc0fc230936f');
INSERT INTO map_member_to_rule VALUES ('86f06119-51b1-4b88-90d6-039b8a3653b5', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'ee992171-d275-4d24-8def-7ff02adec408');
INSERT INTO map_member_to_rule VALUES ('35fbc95c-c2a2-469e-a073-1409404fbc7b', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', '6033984a-a762-4392-b086-a8d2cdac4221');
INSERT INTO map_member_to_rule VALUES ('3a9cf6b6-fe97-475d-9402-cf8a7f7529b9', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', '3040f8e1-051c-4876-8e8e-0ca4910e7e45');
INSERT INTO map_member_to_rule VALUES ('9fdfc627-6d8b-4386-99ac-36b25a0cbbfa', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'beba3e8d-86e5-4e98-b3eb-368da28dba5f');
INSERT INTO map_member_to_rule VALUES ('13a27a73-11d2-4f76-b254-2ba4c3f38b59', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', '5b27108a-2108-4846-a0a8-3c369f873590');
INSERT INTO map_member_to_rule VALUES ('efec22ec-5699-41aa-b1dd-1bafa1c6da2a', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'bff78ebf-2cba-466e-9e3c-89f13a0882fc');
INSERT INTO map_member_to_rule VALUES ('fcb7b6b1-8ac5-407b-9f78-469291682078', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'f4ad42ed-b46b-4b4e-859f-1b69b918a64a');
INSERT INTO map_member_to_rule VALUES ('1338097b-70a8-4bfd-ab36-bd52f60cc5eb', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'fe9cd446-2f4b-4844-9b91-5092c0cabece');
INSERT INTO map_member_to_rule VALUES ('84ed5cd1-5c9c-4b50-a873-10db89598491', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'd782679e-3f0a-4499-bda6-8c2600a3e761');
INSERT INTO map_member_to_rule VALUES ('57f60583-1fb6-4e4f-8c16-4b3c13c7500d', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'b946bd84-93fc-4a70-b325-d23c2804b2e9');
INSERT INTO map_member_to_rule VALUES ('d1c6f391-2ede-403c-8dc9-af5987993645', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'b7adafe9-2d5b-44f3-aa87-681fd48466fa');
INSERT INTO map_member_to_rule VALUES ('66c7862c-1e65-4042-abad-bfbf52d60225', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', '6d590a90-58a1-447f-b5ad-e3c62f80a2ef');
INSERT INTO map_member_to_rule VALUES ('4c134f39-ebbb-4fd4-99cf-522ca5fc38b2', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', '6d590a90-58a1-447f-b5ad-b0582b64571a');


--
-- Data for Name: map_principals_to_stages; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: map_role_to_rule; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: migration; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: options; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO options VALUES ('a3624a17-8591-454c-a80c-eefc94a01ad2', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'default.edition', '00000000-0000-0000-0000-000000000000');
INSERT INTO options VALUES ('57c21607-96bd-44b9-8c49-8f3e3797ed2c', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'default.edition.name', 'All editions');
INSERT INTO options VALUES ('171cf766-0899-4f80-ae25-812394d6e213', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'default.workgroup', '00000000-0000-0000-0000-000000000000');
INSERT INTO options VALUES ('99ae8c4f-599b-4e01-bdb5-be0f191b3c24', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'default.workgroup.name', 'Publishing House');


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO profiles VALUES ('39d40812-fc54-4342-9b98-e1c1f4222d22', 'root', 'root', 'root', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2011-01-07 01:33:13.138+03', '2011-01-07 01:33:13.138+03');


--
-- Data for Name: readiness; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: rules; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO rules VALUES ('2fde426b-ed30-4376-9a7b-25278e8f104a', 'allowed', 	'domain', 'login', 'key', 'Can log in to the program', '', 10);
INSERT INTO rules VALUES ('6406ad57-c889-47c5-acc6-0cd552e9cf5e', 'view', 	 	'domain', 'configuration', 'key', 'Can view the configuration', '', 20);
INSERT INTO rules VALUES ('e55d9548-36fe-4e51-bec2-663235b5383e', 'manage',  	'domain', 'departments', 'key', 'Can manage departments', '', 30);
INSERT INTO rules VALUES ('32e0bb97-2bae-4ce8-865e-cdf0edb3fd93', 'manage',  	'domain', 'employees', 'key', 'Can manage employees', '', 40);
INSERT INTO rules VALUES ('2a3cae11-23ea-41c3-bdb8-d3dfdc0d486a', 'manage',  	'domain', 'editions', 'key', 'Can manage editions', '', 50);
INSERT INTO rules VALUES ('086993e0-56aa-441f-8eaf-437c1c5c9691', 'manage',  	'domain', 'exchange', 'key', 'Can manage the exchange', '', 60);
INSERT INTO rules VALUES ('9d057494-c2c6-41f5-9276-74b33b55c6e3', 'manage',  	'domain', 'roles', 'key', 'Can manage roles', '', 70);
INSERT INTO rules VALUES ('aa4e74ad-116e-4bb2-a910-899c4f288f40', 'manage',  	'domain', 'readiness', 'key', 'Can manage the readiness', '', 80);

INSERT INTO rules VALUES ('76323a53-1c22-4ff4-8f19-5e43d5aa0bd4', 'view', 	 	'editions', 'calendar', 'key', 'Can view calendar', '', 10);
INSERT INTO rules VALUES ('0eecba74-ca40-4b8d-a710-03382483b0f4', 'manage',  	'editions', 'calendar', 'key', 'Can manage the calendar', '', 10);
INSERT INTO rules VALUES ('2d34dbb9-db14-4fe8-a2c8-9a57e328b0b5', 'view', 	 	'editions', 'layouts', 'key', 'Can view layouts', '', 20);
INSERT INTO rules VALUES ('ed9580be-1f36-45d1-9b60-36a2a85e5589', 'manage',  	'editions', 'layouts', 'key', 'Can manage layouts', '', 20);
INSERT INTO rules VALUES ('133743df-52ab-4277-b320-3ede5222cb12', 'work', 	 	'editions', 'documents', 'key', 'Can work with documents', '', 30);
INSERT INTO rules VALUES ('52dc7f72-2057-43c0-831d-55e458d84f39', 'assign',  	'editions', 'documents', 'key', 'Can assign the fascicle', '', 40);

INSERT INTO rules VALUES ('ac0a0d95-c4d3-4bd7-93c3-cc0fc230936f', 'view', 	 	'catalog', 'documents', 'key', 'Can view materials', '', 10);
INSERT INTO rules VALUES ('ee992171-d275-4d24-8def-7ff02adec408', 'create',		'catalog', 'documents', 'key', 'Can create materials', '', 20);
INSERT INTO rules VALUES ('6033984a-a762-4392-b086-a8d2cdac4221', 'assign',	 	'catalog', 'documents', 'key', 'Can assign the editor', '', 30);
INSERT INTO rules VALUES ('3040f8e1-051c-4876-8e8e-0ca4910e7e45', 'delete', 	'catalog', 'documents', 'key', 'Can delete materials', '', 40);
INSERT INTO rules VALUES ('beba3e8d-86e5-4e98-b3eb-368da28dba5f', 'recover', 	'catalog', 'documents', 'key', 'Can recover materials', '', 50);
INSERT INTO rules VALUES ('5b27108a-2108-4846-a0a8-3c369f873590', 'update',  	'catalog', 'documents', 'key', 'Can edit the profile', '', 60);
INSERT INTO rules VALUES ('bff78ebf-2cba-466e-9e3c-89f13a0882fc', 'work', 	 	'catalog', 'files', 'key', 'Can work with files', '', 70);
INSERT INTO rules VALUES ('f4ad42ed-b46b-4b4e-859f-1b69b918a64a', 'add', 	 	'catalog', 'files', 'key', 'Can add files', '', 80);
INSERT INTO rules VALUES ('fe9cd446-2f4b-4844-9b91-5092c0cabece', 'delete',  	'catalog', 'files', 'key', 'Can delete files', '', 90);
INSERT INTO rules VALUES ('d782679e-3f0a-4499-bda6-8c2600a3e761', 'capture', 	'catalog', 'documents', 'key', 'Can capture materials', '', 100);
INSERT INTO rules VALUES ('b946bd84-93fc-4a70-b325-d23c2804b2e9', 'transfer', 	'catalog', 'documents', 'key', 'Can transfer materials', '', 110);
INSERT INTO rules VALUES ('b7adafe9-2d5b-44f3-aa87-681fd48466fa', 'move', 		'catalog', 'documents', 'key', 'Can move materials', '', 120);
INSERT INTO rules VALUES ('6d590a90-58a1-447f-b5ad-e3c62f80a2ef', 'briefcase', 	'catalog', 'documents', 'key', 'Can put in a briefcase', '', 130);
INSERT INTO rules VALUES ('6d590a90-58a1-447f-b5ad-b0582b64571a', 'discuss', 	'catalog', 'documents', 'key', 'Can discuss the materials', '', 140);



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: inprint
--

INSERT INTO sessions VALUES ('5c7a5331-6c11-1014-a920-ade64561c3cc', '39d40812-fc54-4342-9b98-e1c1f4222d22', '', '2011-01-07 01:08:12.808+03', '2011-01-07 01:33:39.865+03');


--
-- Data for Name: stages; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- Data for Name: state; Type: TABLE DATA; Schema: public; Owner: inprint
--



--
-- PostgreSQL database dump complete
--

