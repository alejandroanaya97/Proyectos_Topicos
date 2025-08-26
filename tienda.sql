--
-- PostgreSQL database dump
--

\restrict 99asOnjjIyyGrNwln5x1slBeshmL3YtKiELStcJnGS7UsuMU635IfWKxiLQUk6N

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2025-08-26 13:21:24

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 16404)
-- Name: tienda; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tienda;


ALTER SCHEMA tienda OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 16427)
-- Name: category; Type: TABLE; Schema: tienda; Owner: postgres
--

CREATE TABLE tienda.category (
    category_id integer NOT NULL,
    name character varying(60) NOT NULL,
    description text,
    parent_category_id integer
);


ALTER TABLE tienda.category OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16426)
-- Name: category_category_id_seq; Type: SEQUENCE; Schema: tienda; Owner: postgres
--

CREATE SEQUENCE tienda.category_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tienda.category_category_id_seq OWNER TO postgres;

--
-- TOC entry 4862 (class 0 OID 0)
-- Dependencies: 221
-- Name: category_category_id_seq; Type: SEQUENCE OWNED BY; Schema: tienda; Owner: postgres
--

ALTER SEQUENCE tienda.category_category_id_seq OWNED BY tienda.category.category_id;


--
-- TOC entry 220 (class 1259 OID 16418)
-- Name: customer; Type: TABLE; Schema: tienda; Owner: postgres
--

CREATE TABLE tienda.customer (
    customer_id integer NOT NULL,
    contact_name character varying(40) NOT NULL,
    company_name character varying(40),
    contact_email character varying(128),
    address character varying(120),
    city character varying(30),
    country character varying(30)
);


ALTER TABLE tienda.customer OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16417)
-- Name: customer_customer_id_seq; Type: SEQUENCE; Schema: tienda; Owner: postgres
--

CREATE SEQUENCE tienda.customer_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tienda.customer_customer_id_seq OWNER TO postgres;

--
-- TOC entry 4863 (class 0 OID 0)
-- Dependencies: 219
-- Name: customer_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: tienda; Owner: postgres
--

ALTER SEQUENCE tienda.customer_customer_id_seq OWNED BY tienda.customer.customer_id;


--
-- TOC entry 218 (class 1259 OID 16406)
-- Name: employee; Type: TABLE; Schema: tienda; Owner: postgres
--

CREATE TABLE tienda.employee (
    employee_id integer NOT NULL,
    last_name character varying(40) NOT NULL,
    first_name character varying(20) NOT NULL,
    birth_date date NOT NULL,
    hire_date date,
    address character varying(128),
    city character varying(30),
    country character varying(30),
    reports_to integer
);


ALTER TABLE tienda.employee OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16405)
-- Name: employee_employee_id_seq; Type: SEQUENCE; Schema: tienda; Owner: postgres
--

CREATE SEQUENCE tienda.employee_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tienda.employee_employee_id_seq OWNER TO postgres;

--
-- TOC entry 4864 (class 0 OID 0)
-- Dependencies: 217
-- Name: employee_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: tienda; Owner: postgres
--

ALTER SEQUENCE tienda.employee_employee_id_seq OWNED BY tienda.employee.employee_id;


--
-- TOC entry 224 (class 1259 OID 16441)
-- Name: product; Type: TABLE; Schema: tienda; Owner: postgres
--

CREATE TABLE tienda.product (
    product_id integer NOT NULL,
    product_name character varying(40) NOT NULL,
    category_id integer NOT NULL,
    quantity_per_unit character varying(20),
    unit_price numeric(10,2) NOT NULL,
    units_in_stock integer NOT NULL,
    discontinued boolean DEFAULT false NOT NULL,
    CONSTRAINT product_unit_price_check CHECK ((unit_price >= (0)::numeric)),
    CONSTRAINT product_units_in_stock_check CHECK ((units_in_stock >= 0))
);


ALTER TABLE tienda.product OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16440)
-- Name: product_product_id_seq; Type: SEQUENCE; Schema: tienda; Owner: postgres
--

CREATE SEQUENCE tienda.product_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tienda.product_product_id_seq OWNER TO postgres;

--
-- TOC entry 4865 (class 0 OID 0)
-- Dependencies: 223
-- Name: product_product_id_seq; Type: SEQUENCE OWNED BY; Schema: tienda; Owner: postgres
--

ALTER SEQUENCE tienda.product_product_id_seq OWNED BY tienda.product.product_id;


--
-- TOC entry 226 (class 1259 OID 16456)
-- Name: purchase; Type: TABLE; Schema: tienda; Owner: postgres
--

CREATE TABLE tienda.purchase (
    purchase_id integer NOT NULL,
    customer_id integer NOT NULL,
    employee_id integer NOT NULL,
    total_price numeric(10,2) NOT NULL,
    purchase_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    shipped_date timestamp without time zone,
    ship_address character varying(120),
    ship_city character varying(30),
    ship_country character varying(15),
    CONSTRAINT purchase_total_price_check CHECK ((total_price >= (0)::numeric))
);


ALTER TABLE tienda.purchase OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16474)
-- Name: purchase_item; Type: TABLE; Schema: tienda; Owner: postgres
--

CREATE TABLE tienda.purchase_item (
    purchase_id integer NOT NULL,
    product_id integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    quantity integer NOT NULL,
    CONSTRAINT purchase_item_quantity_check CHECK ((quantity > 0)),
    CONSTRAINT purchase_item_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


ALTER TABLE tienda.purchase_item OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16455)
-- Name: purchase_purchase_id_seq; Type: SEQUENCE; Schema: tienda; Owner: postgres
--

CREATE SEQUENCE tienda.purchase_purchase_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tienda.purchase_purchase_id_seq OWNER TO postgres;

--
-- TOC entry 4866 (class 0 OID 0)
-- Dependencies: 225
-- Name: purchase_purchase_id_seq; Type: SEQUENCE OWNED BY; Schema: tienda; Owner: postgres
--

ALTER SEQUENCE tienda.purchase_purchase_id_seq OWNED BY tienda.purchase.purchase_id;


--
-- TOC entry 4667 (class 2604 OID 16430)
-- Name: category category_id; Type: DEFAULT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.category ALTER COLUMN category_id SET DEFAULT nextval('tienda.category_category_id_seq'::regclass);


--
-- TOC entry 4666 (class 2604 OID 16421)
-- Name: customer customer_id; Type: DEFAULT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.customer ALTER COLUMN customer_id SET DEFAULT nextval('tienda.customer_customer_id_seq'::regclass);


--
-- TOC entry 4665 (class 2604 OID 16409)
-- Name: employee employee_id; Type: DEFAULT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.employee ALTER COLUMN employee_id SET DEFAULT nextval('tienda.employee_employee_id_seq'::regclass);


--
-- TOC entry 4668 (class 2604 OID 16444)
-- Name: product product_id; Type: DEFAULT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.product ALTER COLUMN product_id SET DEFAULT nextval('tienda.product_product_id_seq'::regclass);


--
-- TOC entry 4670 (class 2604 OID 16459)
-- Name: purchase purchase_id; Type: DEFAULT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.purchase ALTER COLUMN purchase_id SET DEFAULT nextval('tienda.purchase_purchase_id_seq'::regclass);


--
-- TOC entry 4851 (class 0 OID 16427)
-- Dependencies: 222
-- Data for Name: category; Type: TABLE DATA; Schema: tienda; Owner: postgres
--

COPY tienda.category (category_id, name, description, parent_category_id) FROM stdin;
1	Alimentos	Productos alimenticios de consumo diario	\N
2	Bebidas	Bebidas frías y calientes	\N
5	Frutas y Verduras	Productos frescos	1
\.


--
-- TOC entry 4849 (class 0 OID 16418)
-- Dependencies: 220
-- Data for Name: customer; Type: TABLE DATA; Schema: tienda; Owner: postgres
--

COPY tienda.customer (customer_id, contact_name, company_name, contact_email, address, city, country) FROM stdin;
1	María Pérez	DistriMP	maria.perez@gmail.com	Av 3 #3-33	Bogotá	Colombia
2	Juan Lopez	\N	juan.lopez@gmail.com	Cll 4 #4-44	Cali	Colombia
3	Sofía López	SL Ltd	sofia.lopez@yahoo.com	Cll 5 #5-55	Cali	Colombia
4	Pedro Quintero	\N	pedro.q@yahoo.com	Cll 6 #6-66	Medellín	Colombia
\.


--
-- TOC entry 4847 (class 0 OID 16406)
-- Dependencies: 218
-- Data for Name: employee; Type: TABLE DATA; Schema: tienda; Owner: postgres
--

COPY tienda.employee (employee_id, last_name, first_name, birth_date, hire_date, address, city, country, reports_to) FROM stdin;
1	Rojas	Ana	1995-04-15	2020-01-10	Cra 1 #1-11	Bogotá	Colombia	\N
2	García	Luis	1988-01-10	2018-03-15	Cll 2 #2-22	Medellín	Colombia	1
\.


--
-- TOC entry 4853 (class 0 OID 16441)
-- Dependencies: 224
-- Data for Name: product; Type: TABLE DATA; Schema: tienda; Owner: postgres
--

COPY tienda.product (product_id, product_name, category_id, quantity_per_unit, unit_price, units_in_stock, discontinued) FROM stdin;
1	Pan tajado Bimbo	1	500 g	7.50	100	f
2	Arroz Diana	1	1 kg	5.00	150	f
3	Aceite Premier	1	1 L	12.00	80	f
4	Huevos AA	1	30 unidades	18.00	60	f
5	Atún Van Camps	1	170 g	7.00	50	f
6	Tomate chonto	5	1 kg	4.50	40	f
7	Cebolla cabezona	5	1 kg	3.80	50	f
8	Plátano hartón	5	1 kg	2.80	70	f
9	Mango Tommy	5	1 kg	6.00	30	f
10	Gaseosa Coca-Cola 1.5L	2	1.5 L	5.50	25	t
11	Jugo Hit Mora 1L	2	1 L	4.20	20	t
12	Cerveza Águila 330ml	2	330 ml	3.50	40	t
13	Café Sello Rojo	2	500 g	12.50	35	f
\.


--
-- TOC entry 4855 (class 0 OID 16456)
-- Dependencies: 226
-- Data for Name: purchase; Type: TABLE DATA; Schema: tienda; Owner: postgres
--

COPY tienda.purchase (purchase_id, customer_id, employee_id, total_price, purchase_date, shipped_date, ship_address, ship_city, ship_country) FROM stdin;
1	1	1	32.00	2025-08-16 11:44:30.61063	2025-08-19 11:44:30.61063	Av 3 #3-33	Bogotá	Colombia
2	3	2	18.50	2025-08-21 11:44:30.61063	2025-08-24 11:44:30.61063	Cll 5 #5-55	Cali	Colombia
\.


--
-- TOC entry 4856 (class 0 OID 16474)
-- Dependencies: 227
-- Data for Name: purchase_item; Type: TABLE DATA; Schema: tienda; Owner: postgres
--

COPY tienda.purchase_item (purchase_id, product_id, unit_price, quantity) FROM stdin;
1	1	7.50	2
1	6	4.50	1
2	10	5.50	2
2	11	4.20	1
\.


--
-- TOC entry 4867 (class 0 OID 0)
-- Dependencies: 221
-- Name: category_category_id_seq; Type: SEQUENCE SET; Schema: tienda; Owner: postgres
--

SELECT pg_catalog.setval('tienda.category_category_id_seq', 1, false);


--
-- TOC entry 4868 (class 0 OID 0)
-- Dependencies: 219
-- Name: customer_customer_id_seq; Type: SEQUENCE SET; Schema: tienda; Owner: postgres
--

SELECT pg_catalog.setval('tienda.customer_customer_id_seq', 1, false);


--
-- TOC entry 4869 (class 0 OID 0)
-- Dependencies: 217
-- Name: employee_employee_id_seq; Type: SEQUENCE SET; Schema: tienda; Owner: postgres
--

SELECT pg_catalog.setval('tienda.employee_employee_id_seq', 1, false);


--
-- TOC entry 4870 (class 0 OID 0)
-- Dependencies: 223
-- Name: product_product_id_seq; Type: SEQUENCE SET; Schema: tienda; Owner: postgres
--

SELECT pg_catalog.setval('tienda.product_product_id_seq', 1, false);


--
-- TOC entry 4871 (class 0 OID 0)
-- Dependencies: 225
-- Name: purchase_purchase_id_seq; Type: SEQUENCE SET; Schema: tienda; Owner: postgres
--

SELECT pg_catalog.setval('tienda.purchase_purchase_id_seq', 1, false);


--
-- TOC entry 4685 (class 2606 OID 16434)
-- Name: category category_pkey; Type: CONSTRAINT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (category_id);


--
-- TOC entry 4680 (class 2606 OID 16425)
-- Name: customer customer_contact_email_key; Type: CONSTRAINT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.customer
    ADD CONSTRAINT customer_contact_email_key UNIQUE (contact_email);


--
-- TOC entry 4682 (class 2606 OID 16423)
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 4678 (class 2606 OID 16411)
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 4688 (class 2606 OID 16449)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- TOC entry 4693 (class 2606 OID 16480)
-- Name: purchase_item purchase_item_pkey; Type: CONSTRAINT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.purchase_item
    ADD CONSTRAINT purchase_item_pkey PRIMARY KEY (purchase_id, product_id);


--
-- TOC entry 4690 (class 2606 OID 16463)
-- Name: purchase purchase_pkey; Type: CONSTRAINT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.purchase
    ADD CONSTRAINT purchase_pkey PRIMARY KEY (purchase_id);


--
-- TOC entry 4683 (class 1259 OID 16492)
-- Name: idx_customer_city; Type: INDEX; Schema: tienda; Owner: postgres
--

CREATE INDEX idx_customer_city ON tienda.customer USING btree (city);


--
-- TOC entry 4686 (class 1259 OID 16491)
-- Name: idx_product_category; Type: INDEX; Schema: tienda; Owner: postgres
--

CREATE INDEX idx_product_category ON tienda.product USING btree (category_id);


--
-- TOC entry 4691 (class 1259 OID 16493)
-- Name: idx_purchase_item_purchase; Type: INDEX; Schema: tienda; Owner: postgres
--

CREATE INDEX idx_purchase_item_purchase ON tienda.purchase_item USING btree (purchase_id);


--
-- TOC entry 4695 (class 2606 OID 16435)
-- Name: category category_parent_category_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.category
    ADD CONSTRAINT category_parent_category_id_fkey FOREIGN KEY (parent_category_id) REFERENCES tienda.category(category_id);


--
-- TOC entry 4694 (class 2606 OID 16412)
-- Name: employee employee_reports_to_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.employee
    ADD CONSTRAINT employee_reports_to_fkey FOREIGN KEY (reports_to) REFERENCES tienda.employee(employee_id);


--
-- TOC entry 4696 (class 2606 OID 16450)
-- Name: product product_category_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.product
    ADD CONSTRAINT product_category_id_fkey FOREIGN KEY (category_id) REFERENCES tienda.category(category_id);


--
-- TOC entry 4697 (class 2606 OID 16464)
-- Name: purchase purchase_customer_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.purchase
    ADD CONSTRAINT purchase_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES tienda.customer(customer_id);


--
-- TOC entry 4698 (class 2606 OID 16469)
-- Name: purchase purchase_employee_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.purchase
    ADD CONSTRAINT purchase_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES tienda.employee(employee_id);


--
-- TOC entry 4699 (class 2606 OID 16486)
-- Name: purchase_item purchase_item_product_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.purchase_item
    ADD CONSTRAINT purchase_item_product_id_fkey FOREIGN KEY (product_id) REFERENCES tienda.product(product_id);


--
-- TOC entry 4700 (class 2606 OID 16481)
-- Name: purchase_item purchase_item_purchase_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: postgres
--

ALTER TABLE ONLY tienda.purchase_item
    ADD CONSTRAINT purchase_item_purchase_id_fkey FOREIGN KEY (purchase_id) REFERENCES tienda.purchase(purchase_id) ON DELETE CASCADE;


-- Completed on 2025-08-26 13:21:25

--
-- PostgreSQL database dump complete
--

\unrestrict 99asOnjjIyyGrNwln5x1slBeshmL3YtKiELStcJnGS7UsuMU635IfWKxiLQUk6N

