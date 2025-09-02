--
-- PostgreSQL database dump
--

\restrict qaZuIZpZ7wCcb0DlvIgXhb2ZFhp1kAWfaNaQyEjxdAJpLu8klNEeVObVcQ5XGfL

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

-- Started on 2025-09-02 11:41:08

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 16406)
-- Name: libros; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.libros (
    id_libro integer NOT NULL,
    titulo character varying(300) NOT NULL,
    autor character varying(200),
    stock integer DEFAULT 0 NOT NULL,
    CONSTRAINT libros_stock_check CHECK ((stock >= 0))
);


ALTER TABLE public.libros OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16405)
-- Name: libros_id_libro_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.libros_id_libro_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.libros_id_libro_seq OWNER TO postgres;

--
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 217
-- Name: libros_id_libro_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.libros_id_libro_seq OWNED BY public.libros.id_libro;


--
-- TOC entry 220 (class 1259 OID 16425)
-- Name: prestamos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prestamos (
    id_prestamos integer NOT NULL,
    id_usuario integer NOT NULL,
    id_libro integer NOT NULL,
    fecha_prestamo date NOT NULL,
    fecha_devolucion date,
    CONSTRAINT prestamos_check CHECK (((fecha_devolucion IS NULL) OR (fecha_devolucion >= fecha_prestamo)))
);


ALTER TABLE public.prestamos OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16424)
-- Name: prestamos_id_prestamos_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.prestamos_id_prestamos_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.prestamos_id_prestamos_seq OWNER TO postgres;

--
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 219
-- Name: prestamos_id_prestamos_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.prestamos_id_prestamos_seq OWNED BY public.prestamos.id_prestamos;


--
-- TOC entry 216 (class 1259 OID 16399)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id_usuario integer NOT NULL,
    nombre character varying(150) NOT NULL,
    email character varying(200)
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16398)
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_usuario_seq OWNER TO postgres;

--
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 215
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_usuario_seq OWNED BY public.usuarios.id_usuario;


--
-- TOC entry 4746 (class 2604 OID 16409)
-- Name: libros id_libro; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libros ALTER COLUMN id_libro SET DEFAULT nextval('public.libros_id_libro_seq'::regclass);


--
-- TOC entry 4748 (class 2604 OID 16428)
-- Name: prestamos id_prestamos; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prestamos ALTER COLUMN id_prestamos SET DEFAULT nextval('public.prestamos_id_prestamos_seq'::regclass);


--
-- TOC entry 4745 (class 2604 OID 16402)
-- Name: usuarios id_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuarios_id_usuario_seq'::regclass);


--
-- TOC entry 4905 (class 0 OID 16406)
-- Dependencies: 218
-- Data for Name: libros; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.libros (id_libro, titulo, autor, stock) FROM stdin;
1	Cien Años de Soledad	Gabriel García Márquez	5
2	El Principito	Antoine de Saint-Exupéry	3
3	Don Quijote de la Mancha	Miguel de Cervantes	4
4	La Sombra del Viento	Carlos Ruiz Zafón	2
5	Crimen y Castigo	Fiódor Dostoievski	1
6	1984	George Orwell	2
7	El Aleph	Jorge Luis Borges	3
8	Rayuela	Julio Cortázar	10
9	Siddhartha	Hermann Hesse	2
10	Moby Dick	Herman Melville	1
\.


--
-- TOC entry 4907 (class 0 OID 16425)
-- Dependencies: 220
-- Data for Name: prestamos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prestamos (id_prestamos, id_usuario, id_libro, fecha_prestamo, fecha_devolucion) FROM stdin;
1	1	1	2025-01-10	2025-01-20
2	1	2	2025-02-01	2025-02-05
3	1	1	2025-03-05	2025-03-15
4	1	3	2025-04-10	2025-04-20
5	2	1	2025-01-20	2025-02-01
6	2	2	2025-03-01	2025-03-10
7	2	4	2025-08-20	\N
8	3	1	2025-05-01	2025-05-10
9	3	4	2025-06-05	2025-06-15
10	4	5	2025-07-01	2025-07-04
11	5	6	2025-07-10	2025-07-18
12	6	2	2025-08-01	2025-08-10
13	7	1	2025-08-15	2025-08-25
14	8	3	2025-09-01	\N
\.


--
-- TOC entry 4903 (class 0 OID 16399)
-- Dependencies: 216
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id_usuario, nombre, email) FROM stdin;
1	Ana Pérez	ana.perez@example.com
2	Carlos Romero	cromero@example.com
3	Laura Gómez	laura.gomez@example.com
4	Diego López	diego.lopez@example.com
5	María Fernández	mfernandez@example.com
6	Andrés Ruiz	andres.ruiz@example.com
7	Sofía Morales	sofia.morales@example.com
8	Javier Castillo	jcastillo@example.com
9	Lorena Díaz	lorena.diaz@example.com
10	Mateo Salazar	mateo.salazar@example.com
\.


--
-- TOC entry 4916 (class 0 OID 0)
-- Dependencies: 217
-- Name: libros_id_libro_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.libros_id_libro_seq', 10, true);


--
-- TOC entry 4917 (class 0 OID 0)
-- Dependencies: 219
-- Name: prestamos_id_prestamos_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prestamos_id_prestamos_seq', 14, true);


--
-- TOC entry 4918 (class 0 OID 0)
-- Dependencies: 215
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_usuario_seq', 10, true);


--
-- TOC entry 4754 (class 2606 OID 16415)
-- Name: libros libros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libros
    ADD CONSTRAINT libros_pkey PRIMARY KEY (id_libro);


--
-- TOC entry 4756 (class 2606 OID 16431)
-- Name: prestamos prestamos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prestamos
    ADD CONSTRAINT prestamos_pkey PRIMARY KEY (id_prestamos);


--
-- TOC entry 4752 (class 2606 OID 16404)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);


--
-- TOC entry 4757 (class 2606 OID 16437)
-- Name: prestamos prestamos_id_libro_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prestamos
    ADD CONSTRAINT prestamos_id_libro_fkey FOREIGN KEY (id_libro) REFERENCES public.libros(id_libro) ON DELETE RESTRICT;


--
-- TOC entry 4758 (class 2606 OID 16432)
-- Name: prestamos prestamos_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prestamos
    ADD CONSTRAINT prestamos_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario) ON DELETE RESTRICT;


-- Completed on 2025-09-02 11:41:08

--
-- PostgreSQL database dump complete
--

\unrestrict qaZuIZpZ7wCcb0DlvIgXhb2ZFhp1kAWfaNaQyEjxdAJpLu8klNEeVObVcQ5XGfL

