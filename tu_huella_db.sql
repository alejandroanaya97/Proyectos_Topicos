--
-- PostgreSQL database dump
--

\restrict ifcTL6riNNgcBicb9qea2WRtKiISBqhdghO5X68a8AQBc0ADvfvUMwNF7tySsKH

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

-- Started on 2025-09-09 12:06:07

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 230 (class 1255 OID 16539)
-- Name: actualizar_inventario(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.actualizar_inventario(IN p_id_producto integer, IN p_cantidad_vendida integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE inventario
    SET inventario_tienda = inventario_tienda - p_cantidad_vendida
    WHERE id_producto = p_id_producto;

    -- Validación: no permitir inventario negativo
    IF (SELECT inventario_tienda FROM inventario WHERE id_producto = p_id_producto) < 0 THEN
        RAISE EXCEPTION 'Inventario insuficiente para el producto %', p_id_producto;
    END IF;
END;
$$;


ALTER PROCEDURE public.actualizar_inventario(IN p_id_producto integer, IN p_cantidad_vendida integer) OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 16538)
-- Name: registrar_contabilidad(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.registrar_contabilidad(IN p_id_factura integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_total DECIMAL(10,2);
BEGIN
    -- Obtener total de la factura
    SELECT fc.total INTO v_total
    FROM factura_cabecera fc
    WHERE fc.id_factura = p_id_factura;

    -- Insertar en contabilidad
    INSERT INTO contabilidad (id_factura, monto)
    VALUES (p_id_factura, v_total);
END;
$$;


ALTER PROCEDURE public.registrar_contabilidad(IN p_id_factura integer) OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 16542)
-- Name: trg_actualizar_inventario(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_actualizar_inventario() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    CALL actualizar_inventario(NEW.id_producto, NEW.cantidad);
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_actualizar_inventario() OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 16540)
-- Name: trg_registrar_contabilidad(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_registrar_contabilidad() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    CALL registrar_contabilidad(NEW.id_factura);
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_registrar_contabilidad() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 16458)
-- Name: carrito; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carrito (
    id_carrito integer NOT NULL,
    id_usuario integer
);


ALTER TABLE public.carrito OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16457)
-- Name: carrito_id_carrito_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.carrito_id_carrito_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.carrito_id_carrito_seq OWNER TO postgres;

--
-- TOC entry 4968 (class 0 OID 0)
-- Dependencies: 217
-- Name: carrito_id_carrito_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.carrito_id_carrito_seq OWNED BY public.carrito.id_carrito;


--
-- TOC entry 228 (class 1259 OID 16527)
-- Name: contabilidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contabilidad (
    id_registro_contable integer NOT NULL,
    id_factura integer,
    monto numeric(10,2)
);


ALTER TABLE public.contabilidad OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16526)
-- Name: contabilidad_id_registro_contable_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contabilidad_id_registro_contable_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contabilidad_id_registro_contable_seq OWNER TO postgres;

--
-- TOC entry 4969 (class 0 OID 0)
-- Dependencies: 227
-- Name: contabilidad_id_registro_contable_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contabilidad_id_registro_contable_seq OWNED BY public.contabilidad.id_registro_contable;


--
-- TOC entry 224 (class 1259 OID 16498)
-- Name: factura_cabecera; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.factura_cabecera (
    id_factura integer NOT NULL,
    id_usuario integer,
    fecha date NOT NULL,
    total numeric(10,2) NOT NULL
);


ALTER TABLE public.factura_cabecera OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16497)
-- Name: factura_cabecera_id_factura_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.factura_cabecera_id_factura_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.factura_cabecera_id_factura_seq OWNER TO postgres;

--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 223
-- Name: factura_cabecera_id_factura_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.factura_cabecera_id_factura_seq OWNED BY public.factura_cabecera.id_factura;


--
-- TOC entry 226 (class 1259 OID 16510)
-- Name: factura_detalle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.factura_detalle (
    id_detalle integer NOT NULL,
    id_factura integer,
    id_producto integer,
    cantidad integer NOT NULL,
    precio_unitario numeric(10,2),
    subtotal numeric(10,2)
);


ALTER TABLE public.factura_detalle OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16509)
-- Name: factura_detalle_id_detalle_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.factura_detalle_id_detalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.factura_detalle_id_detalle_seq OWNER TO postgres;

--
-- TOC entry 4971 (class 0 OID 0)
-- Dependencies: 225
-- Name: factura_detalle_id_detalle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.factura_detalle_id_detalle_seq OWNED BY public.factura_detalle.id_detalle;


--
-- TOC entry 222 (class 1259 OID 16480)
-- Name: inventario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventario (
    id_inventario integer NOT NULL,
    id_producto integer,
    inventario_tienda integer NOT NULL,
    inventario_minimo integer,
    inventario_maximo integer,
    fecha_ultima_actualizacion date,
    id_proveedor integer,
    lote character varying(50),
    fecha_ingreso date,
    valor_unitario numeric(10,2),
    estado character varying(20),
    CONSTRAINT inventario_estado_check CHECK (((estado)::text = ANY ((ARRAY['disponible'::character varying, 'agotado'::character varying, 'en tránsito'::character varying])::text[])))
);


ALTER TABLE public.inventario OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16479)
-- Name: inventario_id_inventario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventario_id_inventario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventario_id_inventario_seq OWNER TO postgres;

--
-- TOC entry 4972 (class 0 OID 0)
-- Dependencies: 221
-- Name: inventario_id_inventario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventario_id_inventario_seq OWNED BY public.inventario.id_inventario;


--
-- TOC entry 220 (class 1259 OID 16470)
-- Name: producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producto (
    id_producto integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    precio_unitario numeric(10,2) NOT NULL,
    cantidad integer NOT NULL,
    estado character varying(20),
    CONSTRAINT producto_estado_check CHECK (((estado)::text = ANY ((ARRAY['activo'::character varying, 'inactivo'::character varying, 'descontinuado'::character varying])::text[])))
);


ALTER TABLE public.producto OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16469)
-- Name: producto_id_producto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.producto_id_producto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.producto_id_producto_seq OWNER TO postgres;

--
-- TOC entry 4973 (class 0 OID 0)
-- Dependencies: 219
-- Name: producto_id_producto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.producto_id_producto_seq OWNED BY public.producto.id_producto;


--
-- TOC entry 216 (class 1259 OID 16444)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    id_usuario integer NOT NULL,
    nombre character varying(100) NOT NULL,
    correo character varying(100) NOT NULL,
    direccion character varying(150),
    telefono character varying(20),
    usuario character varying(50) NOT NULL,
    "contraseña" character varying(100) NOT NULL,
    tipo_usuario character varying(20),
    CONSTRAINT usuario_tipo_usuario_check CHECK (((tipo_usuario)::text = ANY ((ARRAY['administrador'::character varying, 'cliente'::character varying, 'proveedor'::character varying])::text[])))
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16443)
-- Name: usuario_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_id_usuario_seq OWNER TO postgres;

--
-- TOC entry 4974 (class 0 OID 0)
-- Dependencies: 215
-- Name: usuario_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_id_usuario_seq OWNED BY public.usuario.id_usuario;


--
-- TOC entry 4770 (class 2604 OID 16461)
-- Name: carrito id_carrito; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carrito ALTER COLUMN id_carrito SET DEFAULT nextval('public.carrito_id_carrito_seq'::regclass);


--
-- TOC entry 4775 (class 2604 OID 16530)
-- Name: contabilidad id_registro_contable; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contabilidad ALTER COLUMN id_registro_contable SET DEFAULT nextval('public.contabilidad_id_registro_contable_seq'::regclass);


--
-- TOC entry 4773 (class 2604 OID 16501)
-- Name: factura_cabecera id_factura; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factura_cabecera ALTER COLUMN id_factura SET DEFAULT nextval('public.factura_cabecera_id_factura_seq'::regclass);


--
-- TOC entry 4774 (class 2604 OID 16513)
-- Name: factura_detalle id_detalle; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factura_detalle ALTER COLUMN id_detalle SET DEFAULT nextval('public.factura_detalle_id_detalle_seq'::regclass);


--
-- TOC entry 4772 (class 2604 OID 16483)
-- Name: inventario id_inventario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario ALTER COLUMN id_inventario SET DEFAULT nextval('public.inventario_id_inventario_seq'::regclass);


--
-- TOC entry 4771 (class 2604 OID 16473)
-- Name: producto id_producto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto ALTER COLUMN id_producto SET DEFAULT nextval('public.producto_id_producto_seq'::regclass);


--
-- TOC entry 4769 (class 2604 OID 16447)
-- Name: usuario id_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuario_id_usuario_seq'::regclass);


--
-- TOC entry 4952 (class 0 OID 16458)
-- Dependencies: 218
-- Data for Name: carrito; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.carrito (id_carrito, id_usuario) FROM stdin;
1	2
2	4
3	6
4	7
5	9
6	2
7	4
8	6
9	7
10	9
\.


--
-- TOC entry 4962 (class 0 OID 16527)
-- Dependencies: 228
-- Data for Name: contabilidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contabilidad (id_registro_contable, id_factura, monto) FROM stdin;
\.


--
-- TOC entry 4958 (class 0 OID 16498)
-- Dependencies: 224
-- Data for Name: factura_cabecera; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.factura_cabecera (id_factura, id_usuario, fecha, total) FROM stdin;
1	2	2025-08-28	920000.00
2	4	2025-08-29	300000.00
3	6	2025-08-30	680000.00
4	7	2025-08-31	770000.00
5	9	2025-09-01	810000.00
6	2	2025-09-02	510000.00
7	4	2025-09-03	850000.00
8	6	2025-09-04	700000.00
9	7	2025-09-05	770000.00
10	9	2025-09-06	860000.00
\.


--
-- TOC entry 4960 (class 0 OID 16510)
-- Dependencies: 226
-- Data for Name: factura_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.factura_detalle (id_detalle, id_factura, id_producto, cantidad, precio_unitario, subtotal) FROM stdin;
1	1	1	2	350000.00	700000.00
2	1	6	1	220000.00	220000.00
3	2	2	1	300000.00	300000.00
4	3	3	1	280000.00	280000.00
5	3	4	2	200000.00	400000.00
6	4	8	1	450000.00	450000.00
7	4	9	1	320000.00	320000.00
8	5	7	3	270000.00	810000.00
9	6	10	1	290000.00	290000.00
10	6	6	1	220000.00	220000.00
11	7	5	1	250000.00	250000.00
12	7	2	2	300000.00	600000.00
13	8	1	2	350000.00	700000.00
14	9	3	1	280000.00	280000.00
15	9	10	1	290000.00	290000.00
16	9	4	1	200000.00	200000.00
17	10	9	1	320000.00	320000.00
18	10	7	2	270000.00	540000.00
\.


--
-- TOC entry 4956 (class 0 OID 16480)
-- Dependencies: 222
-- Data for Name: inventario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventario (id_inventario, id_producto, inventario_tienda, inventario_minimo, inventario_maximo, fecha_ultima_actualizacion, id_proveedor, lote, fecha_ingreso, valor_unitario, estado) FROM stdin;
1	1	20	5	50	2025-09-01	3	L001	2025-08-20	300000.00	disponible
2	2	15	5	40	2025-09-01	5	L002	2025-08-21	250000.00	disponible
3	3	10	3	30	2025-09-01	3	L003	2025-08-22	230000.00	agotado
4	4	25	5	60	2025-09-01	5	L004	2025-08-23	180000.00	disponible
5	5	12	4	35	2025-09-01	10	L005	2025-08-24	210000.00	disponible
6	6	18	6	40	2025-09-01	3	L006	2025-08-25	190000.00	disponible
7	7	14	4	35	2025-09-01	5	L007	2025-08-26	230000.00	agotado
8	8	8	2	20	2025-09-01	10	L008	2025-08-27	400000.00	disponible
9	9	16	5	40	2025-09-01	3	L009	2025-08-28	270000.00	disponible
10	10	9	3	25	2025-09-01	5	L010	2025-08-29	250000.00	agotado
\.


--
-- TOC entry 4954 (class 0 OID 16470)
-- Dependencies: 220
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto (id_producto, nombre, descripcion, precio_unitario, cantidad, estado) FROM stdin;
1	Nike Air Max	Zapatillas deportivas running	350000.00	20	activo
2	Adidas Superstar	Zapatillas casuales blancas	300000.00	15	activo
3	Puma RS-X	Zapatillas urbanas	280000.00	10	activo
4	Converse Chuck Taylor	Clásicas de lona	200000.00	25	activo
5	Reebok Classic	Estilo retro	250000.00	12	activo
6	Vans Old Skool	Skate shoes	220000.00	18	activo
7	New Balance 574	Casual sport	270000.00	14	activo
8	Jordan 1 Mid	Basketball shoes	450000.00	8	activo
9	Asics Gel-Lyte	Running shoes	320000.00	16	activo
10	Fila Disruptor	Chunky sneakers	290000.00	9	activo
\.


--
-- TOC entry 4950 (class 0 OID 16444)
-- Dependencies: 216
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (id_usuario, nombre, correo, direccion, telefono, usuario, "contraseña", tipo_usuario) FROM stdin;
1	Carlos Pérez	carlos.admin@example.com	Calle 123	3001234567	carlosp	pass123	administrador
2	María López	maria.cliente@example.com	Carrera 45	3019876543	marial	pass123	cliente
3	Luis Gómez	luis.proveedor@example.com	Av 10	3021112233	luisg	pass123	proveedor
4	Ana Torres	ana.cliente@example.com	Calle 56	3004567890	anat	pass123	cliente
5	Pedro Ruiz	pedro.proveedor@example.com	Av 30	3051239876	pedror	pass123	proveedor
6	Laura Martínez	laura.cliente@example.com	Carrera 12	3047896541	lauram	pass123	cliente
7	Sofía Jiménez	sofia.cliente@example.com	Calle 98	3124567890	sofiaj	pass123	cliente
8	Jorge Rojas	jorge.admin@example.com	Carrera 70	3157894561	jorger	pass123	administrador
9	Diego Vargas	diego.cliente@example.com	Av 90	3169876543	diegov	pass123	cliente
10	Camila Fernández	camila.proveedor@example.com	Calle 45	3186543210	camilaf	pass123	proveedor
\.


--
-- TOC entry 4975 (class 0 OID 0)
-- Dependencies: 217
-- Name: carrito_id_carrito_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.carrito_id_carrito_seq', 10, true);


--
-- TOC entry 4976 (class 0 OID 0)
-- Dependencies: 227
-- Name: contabilidad_id_registro_contable_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contabilidad_id_registro_contable_seq', 1, false);


--
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 223
-- Name: factura_cabecera_id_factura_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.factura_cabecera_id_factura_seq', 10, true);


--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 225
-- Name: factura_detalle_id_detalle_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.factura_detalle_id_detalle_seq', 18, true);


--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 221
-- Name: inventario_id_inventario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventario_id_inventario_seq', 10, true);


--
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 219
-- Name: producto_id_producto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.producto_id_producto_seq', 10, true);


--
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 215
-- Name: usuario_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_usuario_seq', 10, true);


--
-- TOC entry 4786 (class 2606 OID 16463)
-- Name: carrito carrito_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carrito
    ADD CONSTRAINT carrito_pkey PRIMARY KEY (id_carrito);


--
-- TOC entry 4796 (class 2606 OID 16532)
-- Name: contabilidad contabilidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contabilidad
    ADD CONSTRAINT contabilidad_pkey PRIMARY KEY (id_registro_contable);


--
-- TOC entry 4792 (class 2606 OID 16503)
-- Name: factura_cabecera factura_cabecera_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factura_cabecera
    ADD CONSTRAINT factura_cabecera_pkey PRIMARY KEY (id_factura);


--
-- TOC entry 4794 (class 2606 OID 16515)
-- Name: factura_detalle factura_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factura_detalle
    ADD CONSTRAINT factura_detalle_pkey PRIMARY KEY (id_detalle);


--
-- TOC entry 4790 (class 2606 OID 16486)
-- Name: inventario inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_pkey PRIMARY KEY (id_inventario);


--
-- TOC entry 4788 (class 2606 OID 16478)
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id_producto);


--
-- TOC entry 4780 (class 2606 OID 16454)
-- Name: usuario usuario_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_correo_key UNIQUE (correo);


--
-- TOC entry 4782 (class 2606 OID 16452)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);


--
-- TOC entry 4784 (class 2606 OID 16456)
-- Name: usuario usuario_usuario_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_usuario_key UNIQUE (usuario);


--
-- TOC entry 4805 (class 2620 OID 16543)
-- Name: factura_detalle after_insert_detalle; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER after_insert_detalle AFTER INSERT ON public.factura_detalle FOR EACH ROW EXECUTE FUNCTION public.trg_actualizar_inventario();


--
-- TOC entry 4804 (class 2620 OID 16541)
-- Name: factura_cabecera after_insert_factura; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER after_insert_factura AFTER INSERT ON public.factura_cabecera FOR EACH ROW EXECUTE FUNCTION public.trg_registrar_contabilidad();


--
-- TOC entry 4797 (class 2606 OID 16464)
-- Name: carrito carrito_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carrito
    ADD CONSTRAINT carrito_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario);


--
-- TOC entry 4803 (class 2606 OID 16533)
-- Name: contabilidad contabilidad_id_factura_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contabilidad
    ADD CONSTRAINT contabilidad_id_factura_fkey FOREIGN KEY (id_factura) REFERENCES public.factura_cabecera(id_factura);


--
-- TOC entry 4800 (class 2606 OID 16504)
-- Name: factura_cabecera factura_cabecera_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factura_cabecera
    ADD CONSTRAINT factura_cabecera_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario);


--
-- TOC entry 4801 (class 2606 OID 16516)
-- Name: factura_detalle factura_detalle_id_factura_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factura_detalle
    ADD CONSTRAINT factura_detalle_id_factura_fkey FOREIGN KEY (id_factura) REFERENCES public.factura_cabecera(id_factura);


--
-- TOC entry 4802 (class 2606 OID 16521)
-- Name: factura_detalle factura_detalle_id_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factura_detalle
    ADD CONSTRAINT factura_detalle_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);


--
-- TOC entry 4798 (class 2606 OID 16487)
-- Name: inventario inventario_id_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);


--
-- TOC entry 4799 (class 2606 OID 16492)
-- Name: inventario inventario_id_proveedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_id_proveedor_fkey FOREIGN KEY (id_proveedor) REFERENCES public.usuario(id_usuario);


-- Completed on 2025-09-09 12:06:08

--
-- PostgreSQL database dump complete
--

\unrestrict ifcTL6riNNgcBicb9qea2WRtKiISBqhdghO5X68a8AQBc0ADvfvUMwNF7tySsKH

