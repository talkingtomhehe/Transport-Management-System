create table owner_info (
	owner_id varchar(32) primary key,
    dob date 
);

create table vehicle (
	reg_id varchar(32),
    brand varchar(32),
    vehicle_age int,
    owner_id varchar(32),
    foreign key (owner_id) references owner_info(owner_id),
    primary key (reg_id, owner_id)
);

create table person (
	Pname varchar(32),
    ssn varchar(32),
    driving_license varchar(32),
    owner_id varchar(32) primary key,
    foreign key (owner_id) references owner_info(owner_id)
);

create table company (
	owner_id varchar(32) primary key,
    Cname varchar(32),
    Cid varchar(32),
    foreign key (owner_id) references owner_info(owner_id)
);

create table traffic_violation (
	owner_id varchar(32),
    violation_time datetime,
    violation_name varchar(32),
    violation_address varchar(32),
    violation_description varchar(255),
    primary key (owner_id, violation_time),
    foreign key (owner_id) references owner_info(owner_id) 
);

create table phone_number (
	owner_id varchar(32),
    phone_number varchar(32) unique,
    isp varchar(32),
    region varchar(32) default 'Vietnam',
    primary key (owner_id, phone_number),
    foreign key (owner_id) references owner_info(owner_id)
);

create table sell (
	buyer_id varchar(32),
    reg_id varchar(32),
    seller_id varchar(32),
    primary key (buyer_id, seller_id),
    foreign key (buyer_id) references owner_info(owner_id),
    foreign key (seller_id) references owner_info(owner_id),
    foreign key (reg_id) references vehicle(reg_id)
);

create table insurance (
	insurance_number int primary key,
    company_name varchar(32),
    insurance_value int,
    insurance_type varchar(32),
    reg_id varchar(32),
    started_date date,
    expired_date date,
    foreign key (reg_id) references vehicle(reg_id)
);

create table vehicle_damage_history (
	damage_history varchar(255),
    reg_id varchar(32),
    primary key (reg_id, damage_history),
    foreign key (reg_id) references vehicle(reg_id)
);

create table public_vehicle (
	reg_id varchar(32) not null unique,
    maximum_capacity int,
    vehicle_type varchar(32), 
    model varchar(32),
    license_plate_no varchar(32),
    foreign key (reg_id) references vehicle(reg_id),
    primary key (license_plate_no),
    constraint check_type check (vehicle_type in ('bus', 'train', 'Bus', 'Train'))
);

create table private_vehicle (
	reg_id varchar(32) primary key,
    plate_number varchar(32),
    vehicle_type varchar(32),
    foreign key (reg_id) references vehicle(reg_id)
);

create table driving_employee (
	ssi varchar(32) primary key,
    working_date date,
    working_hours varchar(32),
    age int,
    driver_type varchar(32),
    driving_certifications varchar(32),
    license_plate_no varchar(32),
    driving_certification varchar(32),
    date_taken date,
    date_expired date,
    foreign key (license_plate_no) references public_vehicle(license_plate_no)
);

create table route (
	route_id varchar(32),
    reg_id varchar(32),
    primary key(route_id, reg_id),
    foreign key (reg_id) references public_vehicle(reg_id)
);

create table station_stop (
	station_name varchar(32) primary key,
    address varchar(32),
    capacity varchar(32),
    purpose varchar(32),
    number_of_vehicle int
);

create table bus_order (
	station_name varchar(32),
    bus_order varchar(32),
    foreign key (station_name) references station_stop(station_name),
    primary key (station_name, bus_order)
);

create table go_pass (
	route_id varchar(32),
    station_name varchar(32),
    departure_time time,
    arrival_time time,
    primary key (route_id, station_name),
    foreign key (route_id) references route(route_id),
    foreign key (station_name) references station_stop(station_name)
);

create table cargo (
	cargo_id varchar(32) primary key,
    cargo_date date,
    note varchar(32),
    weight varchar(32),
    receiver varchar(32),
    sender varchar(32),
    dim varchar(32),
    receiver_ssn varchar(32),
    sender_ssn varchar(32),
    from_locations varchar(32),
    receiver_name varchar(32),
    sender_name varchar(32)
);

create table deliver (
	reg_id	varchar(32),
    station_name varchar(32),
    cargo_id varchar(32) primary key,
    foreign key (reg_id) references public_vehicle(reg_id),
    foreign key (station_name) references station_stop(station_name),
    foreign key (cargo_id) references cargo(cargo_id)
);

create table customer (
	ssi_passport varchar(32) primary key,
    gender varchar(32),
    age int,
    customer_name varchar(32),
    nationality varchar(32)
);

create table passenger (
    ssi_passport varchar(32),
    get_on_time datetime,
    reg_id varchar(32),
    depart_location varchar(32),
    destination varchar(32),
    get_off_time datetime,
    foreign key (reg_id) references public_vehicle(reg_id),
    foreign key (ssi_passport) references customer(ssi_passport),
    primary key (ssi_passport, get_on_time, reg_id)
);

create table parent (
	parent_ssi_passport varchar(32),
    child_ssi_passport varchar(32),
    primary key (parent_ssi_passport, child_ssi_passport),
	foreign key (child_ssi_passport) references customer(ssi_passport),
    foreign key (parent_ssi_passport) references customer(ssi_passport)
);

create table belongs (
	ssi_passport varchar(32),
    get_on_time datetime,
    reg_id varchar(32),
    belong_name varchar(32),
    weight double,
    numbers int,
    dim varchar(32),
    primary key (ssi_passport, get_on_time, reg_id, belong_name),    
    foreign key (ssi_passport, get_on_time, reg_id) references passenger(ssi_passport, get_on_time, reg_id)
);

create table regular_parking (
	address varchar(32) primary key,
    parking_type varchar(32),
    capacity varchar(32),
    no_of_vehicle int unique auto_increment
);

create table park (
	reg_id varchar(32),
    address varchar(32),
    primary key (reg_id, address),
    foreign key (reg_id) references private_vehicle(reg_id)
);

create table parking_time (
	id int not null,
	reg_id varchar(32), 
    park_id varchar(32),
    address varchar(32),
    from_time time,
    to_time time,
    parking_day date,
    primary key (park_id),
    foreign key (reg_id, address) references park(reg_id, address),
    constraint duration check (to_time > from_time)
);

create table disabled_language(
	id int,
    primary key (id),
	reg_id varchar(32), 
    park_id varchar(32) not null,
    address varchar(32),
    from_time time,
    to_time time,
    parking_day date
);

INSERT INTO owner_info (owner_id, dob) VALUES
('OWN001', '1970-05-15'),
('OWN002', '1985-12-22'),
('OWN003', '1990-07-08'),
('OWN004', '1976-03-14'),
('OWN005', '1965-11-30'),
('OWN006', '1982-02-17'),
('OWN007', '1995-04-19'),
('OWN008', '1971-09-05'),
('OWN009', '1988-06-23'),
('OWN010', '1974-10-16');

-- Inserting data into 'vehicle'
INSERT INTO vehicle (reg_id, brand, vehicle_age, owner_id) VALUES
('VEH001', 'Toyota', 5, 'OWN001'),
('VEH002', 'Honda', 3, 'OWN002'),
('VEH003', 'Ford', 2, 'OWN003'),
('VEH004', 'Chevrolet', 4, 'OWN004'),
('VEH005', 'Hyundai', 6, 'OWN005'),
('VEH006', 'Kia', 1, 'OWN006'),
('VEH007', 'Mazda', 7, 'OWN007'),
('VEH008', 'BMW', 8, 'OWN008'),
('VEH009', 'Mercedes', 9, 'OWN009'),
('VEH010', 'Audi', 10, 'OWN010');

INSERT INTO vehicle (reg_id, brand, vehicle_age, owner_id) VALUES
('VEH011', 'Toyota', 5, 'OWN001'),
('VEH012', 'Honda', 3, 'OWN002'),
('VEH013', 'Ford', 2, 'OWN003'),
('VEH014', 'Yamaha', 4, 'OWN004'),
('VEH015', 'Hyundai', 6, 'OWN005'),
('VEH016', 'Honda', 1, 'OWN006'),
('VEH017', 'Mazda', 7, 'OWN007'),
('VEH018', 'Yamaha', 8, 'OWN008'),
('VEH019', 'Mercedes', 9, 'OWN009'),
('VEH020', 'Honda', 10, 'OWN010');

-- Inserting data into 'person'
INSERT INTO person (Pname, ssn, driving_license, owner_id) VALUES
('Nguyen Van A', 'SSN001', 'DL001', 'OWN001'),
('Tran Thi B', 'SSN002', 'DL002', 'OWN002'),
('Le Van C', 'SSN003', 'DL003', 'OWN003'),
('Pham Thi D', 'SSN004', 'DL004', 'OWN004'),
('Hoang Van E', 'SSN005', 'DL005', 'OWN005'),
('Bui Thi F', 'SSN006', 'DL006', 'OWN006'),
('Vu Van G', 'SSN007', 'DL007', 'OWN007'),
('Dang Thi H', 'SSN008', 'DL008', 'OWN008'),
('Do Van I', 'SSN009', 'DL009', 'OWN009'),
('Nguyen Thi J', 'SSN010', 'DL010', 'OWN010');

-- Inserting data into 'company'
INSERT INTO company (owner_id, Cname, Cid) VALUES
('OWN001', 'Giao Thong Co.', 'CID001'),
('OWN002', 'Van Tai Co.', 'CID002'),
('OWN003', 'Du Lich Co.', 'CID003'),
('OWN004', 'Phuong Trang Co.', 'CID004'),
('OWN005', 'Mai Linh Co.', 'CID005'),
('OWN006', 'Vinasun Co.', 'CID006'),
('OWN007', 'Thuan Thao Co.', 'CID007'),
('OWN008', 'VietJet Co.', 'CID008'),
('OWN009', 'Bamboo Co.', 'CID009'),
('OWN010', 'Vietnam Airlines Co.', 'CID010');

-- Inserting data into 'traffic_violation'
INSERT INTO traffic_violation (owner_id, violation_time, violation_name, violation_address, violation_description) VALUES
('OWN001', '2024-04-01 08:30:00', 'Speeding', 'District 1', 'Exceeded speed limit by 20km/h'),
('OWN002', '2024-04-02 09:15:00', 'Parking Violation', 'District 3', 'Parked in a no-parking zone'),
('OWN003', '2024-04-03 10:45:00', 'Signal Jumping', 'District 5', 'Passed red light at intersection'),
('OWN004', '2024-04-04 11:30:00', 'Illegal U-Turn', 'District 7', 'Made illegal U-turn in restricted area'),
('OWN005', '2024-04-05 12:00:00', 'Unregistered Vehicle', 'District 9', 'Vehicle not registered with DMV'),
('OWN006', '2024-04-06 13:20:00', 'No Helmet', 'District 11', 'Riding motorbike without a helmet'),
('OWN007', '2024-04-07 14:50:00', 'No Seatbelt', 'District 2', 'Driver not wearing seatbelt'),
('OWN008', '2024-04-08 15:10:00', 'Jaywalking', 'District 4', 'Crossing street outside of crosswalk'),
('OWN009', '2024-04-09 16:25:00', 'Blocking Traffic', 'District 6', 'Vehicle stopped in traffic lane, causing delay'),
('OWN010', '2024-04-10 17:40:00', 'Expired Tags', 'District 8', 'License plate tags expired');

-- Inserting data into 'phone_number'
INSERT INTO phone_number (owner_id, phone_number, isp, region) VALUES
('OWN001', '0983000001', 'Viettel', 'Vietnam'),
('OWN002', '0983000002', 'Mobifone', 'Vietnam'),
('OWN003', '0983000003', 'Vinaphone', 'Vietnam'),
('OWN004', '0983000004', 'Vietnammobile', 'Vietnam'),
('OWN005', '0983000005', 'Gmobile', 'Vietnam'),
('OWN006', '0983000006', 'Viettel', 'Vietnam'),
('OWN007', '0983000007', 'Mobifone', 'Vietnam'),
('OWN008', '0983000008', 'Vinaphone', 'Vietnam'),
('OWN009', '0983000009', 'Vietnammobile', 'Vietnam'),
('OWN010', '0983000010', 'Gmobile', 'Vietnam');

-- Inserting data into 'sell'
INSERT INTO sell (buyer_id, reg_id, seller_id) VALUES
('OWN002', 'VEH001', 'OWN001'),
('OWN003', 'VEH002', 'OWN002'),
('OWN004', 'VEH003', 'OWN003'),
('OWN005', 'VEH004', 'OWN004'),
('OWN006', 'VEH005', 'OWN005'),
('OWN007', 'VEH006', 'OWN006'),
('OWN008', 'VEH007', 'OWN007'),
('OWN009', 'VEH008', 'OWN008'),
('OWN010', 'VEH009', 'OWN009'),
('OWN001', 'VEH010', 'OWN010');

-- Inserting data into 'insurance'
INSERT INTO insurance (insurance_number, company_name, insurance_value, insurance_type, reg_id, started_date, expired_date) VALUES
(1001, 'Bao Viet', 5000000, 'REQ', 'VEH001', '2024-01-01', '2025-01-01'),
(1002, 'PTI', 3000000, 'REQ', 'VEH002', '2024-02-01', '2025-02-01'),
(1003, 'PVI', 4000000, 'REQ', 'VEH003', '2024-03-01', '2025-03-01'),
(1004, 'MIC', 2500000, 'REQ', 'VEH004', '2024-04-01', '2025-04-01'),
(1005, 'VNI', 3500000, 'REQ', 'VEH005', '2024-05-01', '2025-05-01'),
(1006, 'BIC', 4500000, 'REQ', 'VEH006', '2024-06-01', '2025-06-01'),
(1007, 'ABI', 5500000, 'REQ', 'VEH007', '2024-07-01', '2025-07-01'),
(1008, 'BAOVIET', 6000000, 'REQ', 'VEH008', '2024-08-01', '2025-08-01'),
(1009, 'PJICO', 7000000, 'REQ', 'VEH009', '2024-09-01', '2025-09-01'),
(1010, 'PTI', 8000000, 'REQ', 'VEH010', '2024-10-01', '2025-10-01');

-- Inserting data into 'vehicle_damage_history'
INSERT INTO vehicle_damage_history (damage_history, reg_id) VALUES
('Accident on 2024-03-01', 'VEH001'),
('Flood damage on 2024-03-15', 'VEH002'),
('Scratched on 2024-03-20', 'VEH003'),
('Windshield cracked on 2024-03-25', 'VEH004'),
('Tire burst on 2024-03-30', 'VEH005'),
('Engine failure on 2024-04-04', 'VEH006'),
('Battery died on 2024-04-09', 'VEH007'),
('Brake failure on 2024-04-14', 'VEH008'),
('Overheating on 2024-04-19', 'VEH009'),
('Transmission issues on 2024-04-24', 'VEH010');

-- Inserting data into 'public_vehicle'
INSERT INTO public_vehicle (reg_id, maximum_capacity, vehicle_type, model, license_plate_no) VALUES
('VEH001', 50, 'Bus', 'Hyundai County', '30A-12345'),
('VEH002', 30, 'Train', 'Ford Transit', '30B-67890'),
('VEH003', 35, 'Bus', 'Mercedes Sprinter', '30C-23456'),
('VEH004', 40, 'Bus', 'Volvo B7R', '30D-34567'),
('VEH005', 45, 'Bus', 'Scania K-series', '30E-45678'),
('VEH006', 50, 'Train', 'MAN Lion\'s City', '30F-56789'),
('VEH007', 55, 'Bus', 'Iveco Bus Urbanway', '30G-67890'),
('VEH008', 60, 'Bus', 'Blue Bird Vision', '30H-78901'),
('VEH009', 65, 'Bus', 'Thomas Saf-T-Liner', '30I-89012'),
('VEH010', 70, 'Bus', 'Alexander Dennis Enviro', '30J-90123');

-- Inserting data into 'private_vehicle'
INSERT INTO private_vehicle (reg_id, plate_number, vehicle_type) VALUES
('VEH011', '29C-33333', 'Car'),
('VEH012', '29C-44444', 'Motorbike'),
('VEH013', '29C-55555', 'Car'),
('VEH014', '29C-66666', 'Motorbike'),
('VEH015', '29C-77777', 'Car'),
('VEH016', '29C-88888', 'Motorbike'),
('VEH017', '29C-99999', 'Car'),
('VEH018', '29C-10101', 'Motorbike'),
('VEH019', '29C-20202', 'Car'),
('VEH020', '29C-30303', 'Motorbike');

-- Inserting data into 'driving_employee'
INSERT INTO driving_employee (ssi, working_date, working_hours, age, driver_type, driving_certifications, license_plate_no, driving_certification, date_taken, date_expired) VALUES
('SSN001', '2024-04-01', '8 hours', 35, 'Professional', 'A1', '30A-12345', 'D1', '2020-01-01', '2025-01-01'),
('SSN002', '2024-04-02', '6 hours', 40, 'Part-time', 'B2', '30B-67890', 'D2', '2021-02-01', '2026-02-01'),
('SSN003', '2024-04-03', '7 hours', 45, 'Professional', 'C1', '30C-23456', 'D3', '2019-03-01', '2024-03-01'),
('SSN004', '2024-04-04', '5 hours', 30, 'Part-time', 'D2', '30D-34567', 'D4', '2022-04-01', '2027-04-01'),
('SSN005', '2024-04-05', '9 hours', 50, 'Professional', 'E1', '30E-45678', 'D5', '2018-05-01', '2023-05-01'),
('SSN006', '2024-04-06', '8 hours', 55, 'Part-time', 'F2', '30F-56789', 'D6', '2023-06-01', '2028-06-01'),
('SSN007', '2024-04-07', '6 hours', 60, 'Professional', 'G1', '30G-67890', 'D7', '2021-07-01', '2026-07-01'),
('SSN008', '2024-04-08', '7 hours', 25, 'Part-time', 'H2', '30H-78901', 'D8', '2020-08-01', '2025-08-01'),
('SSN009', '2024-04-09', '8 hours', 28, 'Professional', 'I1', '30I-89012', 'D9', '2019-09-01', '2024-09-01'),
('SSN010', '2024-04-10', '5 hours', 33, 'Part-time', 'J2', '30J-90123', 'D10', '2022-10-01', '2027-10-01');

-- Inserting data into 'route'
INSERT INTO route (route_id, reg_id) VALUES
('RT001', 'VEH001'),
('RT002', 'VEH002'),
('RT003', 'VEH003'),
('RT004', 'VEH004'),
('RT005', 'VEH005'),
('RT006', 'VEH006'),
('RT007', 'VEH007'),
('RT008', 'VEH008'),
('RT009', 'VEH009'),
('RT010', 'VEH010');

-- Inserting data into 'station_stop'
INSERT INTO station_stop (station_name, address, capacity, purpose, number_of_vehicle) VALUES
('Ben Thanh', 'District 1', 'Large', 'Main Station', 50),
('Cho Lon', 'District 5', 'Medium', 'Secondary Station', 30),
('Tan Binh', 'District 7', 'Small', 'Local Station', 20),
('Phu Nhuan', 'District 9', 'Medium', 'Local Station', 25),
('Thu Duc', 'District 11', 'Large', 'Main Station', 45),
('Binh Thanh', 'District 2', 'Small', 'Local Station', 15),
('Go Vap', 'District 4', 'Medium', 'Secondary Station', 35),
('Tan Phu', 'District 6', 'Large', 'Main Station', 55),
('Cu Chi', 'District 8', 'Medium', 'Local Station', 40),
('Binh Chanh', 'District 10', 'Small', 'Secondary Station', 10);

-- Inserting data into 'bus_order'
INSERT INTO bus_order (station_name, bus_order) VALUES
('Ben Thanh', 'First'),
('Cho Lon', 'Second'),
('Tan Binh', 'Third'),
('Phu Nhuan', 'Fourth'),
('Thu Duc', 'Fifth'),
('Binh Thanh', 'Sixth'),
('Go Vap', 'Seventh'),
('Tan Phu', 'Eighth'),
('Cu Chi', 'Ninth'),
('Binh Chanh', 'Tenth');

-- Inserting data into 'go_pass'
INSERT INTO go_pass (route_id, station_name, departure_time, arrival_time) VALUES
('RT001', 'Ben Thanh', '06:00:00', '06:30:00'),
('RT002', 'Cho Lon', '07:00:00', '07:45:00'),
('RT003', 'Tan Binh', '08:00:00', '08:30:00'),
('RT004', 'Phu Nhuan', '09:00:00', '09:45:00'),
('RT005', 'Thu Duc', '10:00:00', '10:30:00'),
('RT006', 'Binh Thanh', '11:00:00', '11:45:00'),
('RT007', 'Go Vap', '12:00:00', '12:30:00'),
('RT008', 'Tan Phu', '13:00:00', '13:45:00'),
('RT009', 'Cu Chi', '14:00:00', '14:30:00'),
('RT010', 'Binh Chanh', '15:00:00', '15:45:00');

-- Inserting data into 'cargo'
INSERT INTO cargo (cargo_id, cargo_date, note, weight, receiver, sender, dim, receiver_ssn, sender_ssn, from_locations, receiver_name, sender_name) VALUES
('CG001', '2024-04-01', 'Fragile', '20', 'Nguyen Van A', 'Tran Thi B', '50x30x20', 'SSN001', 'SSN002', 'Hanoi', 'Le Van C', 'Pham Thi D'),
('CG002', '2024-04-02', 'Perishable', '15', 'Hoang Van E', 'Bui Thi F', '40x25x15', 'SSN003', 'SSN004', 'Da Nang', 'Vu Van G', 'Dang Thi H'),
('CG003', '2024-04-03', 'Electronic', '25', 'Vu Van I', 'Do Thi J', '60x40x30', 'SSN005', 'SSN006', 'Hai Phong', 'Nguyen Van K', 'Tran Thi L'),
('CG004', '2024-04-04', 'Clothing', '10', 'Le Van M', 'Pham Thi N', '30x20x10', 'SSN007', 'SSN008', 'Can Tho', 'Hoang Van O', 'Bui Thi P'),
('CG005', '2024-04-05', 'Books', '5', 'Vu Van Q', 'Dang Thi R', '25x15x5', 'SSN009', 'SSN010', 'Nha Trang', 'Nguyen Van S', 'Tran Thi T'),
('CG006', '2024-04-06', 'Furniture', '50', 'Le Van U', 'Pham Thi V', '100x50x50', 'SSN011', 'SSN012', 'Phu Quoc', 'Hoang Van W', 'Bui Thi X'),
('CG007', '2024-04-07', 'Toys', '8', 'Vu Van Y', 'Dang Thi Z', '35x25x20', 'SSN013', 'SSN014', 'Vung Tau', 'Nguyen Van AA', 'Tran Thi BB'),
('CG008', '2024-04-08', 'Art Supplies', '12', 'Le Van CC', 'Pham Thi DD', '45x35x25', 'SSN015', 'SSN016', 'Dong Nai', 'Hoang Van EE', 'Bui Thi FF'),
('CG009', '2024-04-09', 'Medical Equipment', '30', 'Vu Van GG', 'Dang Thi HH', '55x45x35', 'SSN017', 'SSN018', 'Binh Duong', 'Nguyen Van II', 'Tran Thi JJ'),
('CG010', '2024-04-10', 'Automotive Parts', '40', 'Le Van KK', 'Pham Thi LL', '65x55x45', 'SSN019', 'SSN020', 'Da Lat', 'Hoang Van MM', 'Bui Thi NN');

-- Inserting data into 'deliver'
INSERT INTO deliver (reg_id, station_name, cargo_id) VALUES
('VEH001', 'Ben Thanh', 'CG001'),
('VEH002', 'Cho Lon', 'CG002'),
('VEH003', 'Tan Binh', 'CG003'),
('VEH004', 'Phu Nhuan', 'CG004'),
('VEH005', 'Thu Duc', 'CG005'),
('VEH006', 'Binh Thanh', 'CG006'),
('VEH007', 'Go Vap', 'CG007'),
('VEH008', 'Tan Phu', 'CG008'),
('VEH009', 'Cu Chi', 'CG009'),
('VEH010', 'Binh Chanh', 'CG010');

-- Inserting data into 'customer'
INSERT INTO customer (ssi_passport, gender, age, customer_name, nationality) VALUES
('SSI001', 'Male', 30, 'Nguyen Van A', 'Vietnamese'),
('SSI002', 'Female', 25, 'Tran Thi B', 'Vietnamese'),
('SSI003', 'Male', 28, 'Vu Van C', 'Vietnamese'),
('SSI004', 'Female', 32, 'Dang Thi D', 'Vietnamese'),
('SSI005', 'Male', 35, 'Le Van E', 'Vietnamese'),
('SSI006', 'Female', 22, 'Pham Thi F', 'Vietnamese'),
('SSI007', 'Male', 40, 'Hoang Van G', 'Vietnamese'),
('SSI008', 'Female', 27, 'Bui Thi H', 'Vietnamese'),
('SSI009', 'Male', 45, 'Vu Van I', 'Vietnamese'),
('SSI010', 'Female', 20, 'Dang Thi J', 'Vietnamese');

-- Inserting data into 'passenger'
INSERT INTO passenger (ssi_passport, get_on_time, reg_id, depart_location, destination, get_off_time) VALUES
('SSI001', '2024-04-23 06:00:00', 'VEH001', 'District 1', 'District 5', '2024-04-23 06:30:00'),
('SSI002', '2024-04-23 07:00:00', 'VEH002', 'District 3', 'District 10', '2024-04-23 07:45:00'),
('SSI003', '2024-04-23 08:00:00', 'VEH003', 'District 5', 'District 7', '2024-04-23 08:30:00'),
('SSI004', '2024-04-21 09:00:00', 'VEH004', 'District 7', 'District 9', '2024-04-21 09:45:00'),
('SSI005', '2024-04-21 10:00:00', 'VEH005', 'District 9', 'District 11', '2024-04-21 10:30:00'),
('SSI006', '2024-04-23 11:00:00', 'VEH006', 'District 11', 'District 2', '2024-04-23 11:45:00'),
('SSI007', '2024-04-23 12:00:00', 'VEH007', 'District 2', 'District 4', '2024-04-23 12:30:00'),
('SSI008', '2024-04-23 13:00:00', 'VEH008', 'District 4', 'District 6', '2024-04-23 13:45:00'),
('SSI009', '2024-04-22 14:00:00', 'VEH009', 'District 6', 'District 8', '2024-04-22 14:30:00'),
('SSI010', '2024-04-23 15:00:00', 'VEH010', 'District 8', 'District 10', '2024-04-23 15:45:00');

-- Inserting data into 'belongs'
INSERT INTO belongs (ssi_passport, get_on_time, reg_id, belong_name, weight, numbers, dim) VALUES
('SSI001', '2024-04-23 06:00:00', 'VEH001', 'Luggage', 15, 1, '55x35x20'),
('SSI002', '2024-04-23 07:00:00', 'VEH002', 'Backpack', 5, 1, '30x20x15'),
('SSI003', '2024-04-23 08:00:00', 'VEH003', 'Briefcase', 3, 1, '40x30x10'),
('SSI004', '2024-04-21 09:00:00', 'VEH004', 'Duffel Bag', 10, 2, '60x40x25'),
('SSI005', '2024-04-21 10:00:00', 'VEH005', 'Handbag', 2, 1, '25x15x10'),
('SSI006', '2024-04-23 11:00:00', 'VEH006', 'Suitcase', 20, 1, '70x50x30'),
('SSI007', '2024-04-23 12:00:00', 'VEH007', 'Guitar Case', 5, 1, '100x35x10'),
('SSI008', '2024-04-23 13:00:00', 'VEH008', 'Shopping Bags', 8, 3, '45x35x20'),
('SSI009', '2024-04-22 14:00:00', 'VEH009', 'Box', 25, 1, '80x60x40'),
('SSI010', '2024-04-23 15:00:00', 'VEH010', 'Sports Equipment', 12, 2, '90x40x30');

-- Inserting data into 'regular_parking'
INSERT INTO regular_parking (address, parking_type, capacity) VALUES
('123 Le Loi', 'Underground', '100'),
('456 Hai Ba Trung', 'Multi-level', '200'),
('789 Vo Van Kiet', 'Surface', '150'),
('1011 Tran Hung Dao', 'Automated', '120'),
('1213 Le Duan', 'Underground', '80'),
('1415 Pham Ngu Lao', 'Multi-level', '220'),
('1617 Nguyen Hue', 'Surface', '130'),
('1819 Ham Nghi', 'Automated', '110'),
('2021 Ton Duc Thang', 'Underground', '90'),
('2223 Nguyen Van Troi', 'Multi-level', '210');

-- Inserting data into 'park'
INSERT INTO park (reg_id, address) VALUES
('VEH011', '123 Le Loi'),
('VEH012', '456 Hai Ba Trung'),
('VEH013', '789 Vo Van Kiet'),
('VEH014', '1011 Tran Hung Dao'),
('VEH015', '1213 Le Duan'),
('VEH016', '1415 Pham Ngu Lao'),
('VEH017', '1617 Nguyen Hue'),
('VEH018', '1819 Ham Nghi'),
('VEH019', '2021 Ton Duc Thang'),
('VEH020', '2223 Nguyen Van Troi');

-- Inserting data into 'parking_time'
INSERT INTO parking_time (id, reg_id, park_id, address, from_time, to_time, parking_day) VALUES
(1, 'VEH011', 'PK001', '123 Le Loi', '08:00:00', '18:00:00', '2024-04-01'),
(2, 'VEH012', 'PK002', '456 Hai Ba Trung', '09:00:00', '17:00:00', '2024-04-02'),
(3, 'VEH013', 'PK003', '789 Vo Van Kiet', '10:00:00', '16:00:00', '2024-04-03'),
(4, 'VEH014', 'PK004', '1011 Tran Hung Dao', '11:00:00', '15:00:00', '2024-04-04'),
(5, 'VEH015', 'PK005', '1213 Le Duan', '12:00:00', '14:00:00', '2024-04-05'),
(6, 'VEH016', 'PK006', '1415 Pham Ngu Lao', '13:00:00', '19:00:00', '2024-04-06'),
(7, 'VEH017', 'PK007', '1617 Nguyen Hue', '14:00:00', '20:00:00', '2024-04-07'),
(8, 'VEH018', 'PK008', '1819 Ham Nghi', '15:00:00', '21:00:00', '2024-04-08'),
(9, 'VEH019', 'PK009', '2021 Ton Duc Thang', '16:00:00', '22:00:00', '2024-04-09'),
(10, 'VEH020', 'PK010', '2223 Nguyen Van Troi', '17:00:00', '23:00:00', '2024-04-10');

-- Inserting data into 'disabled_language'
INSERT INTO disabled_language (id, reg_id, park_id, address, from_time, to_time, parking_day) VALUES
(1, 'VEH011', 'PK001', '123 Le Loi', '08:00:00', '18:00:00', '2024-04-01'),
(2, 'VEH012', 'PK002', '456 Hai Ba Trung', '09:00:00', '17:00:00', '2024-04-02'),
(3, 'VEH013', 'PK003', '789 Tran Hung Dao', '07:00:00', '19:00:00', '2024-04-03'),
(4, 'VEH014', 'PK004', '1010 Cach Mang Thang Tam', '06:00:00', '20:00:00', '2024-04-04'),
(5, 'VEH015', 'PK005', '1111 Ly Thuong Kiet', '10:00:00', '22:00:00', '2024-04-05'),
(6, 'VEH016', 'PK006', '1212 Nguyen Trai', '11:00:00', '23:00:00', '2024-04-06'),
(7, 'VEH017', 'PK007', '1313 Le Duan', '12:00:00', '24:00:00', '2024-04-07'),
(8, 'VEH018', 'PK008', '1414 Vo Van Kiet', '13:00:00', '21:00:00', '2024-04-08'),
(9, 'VEH019', 'PK009', '1515 Nguyen Van Cu', '14:00:00', '16:00:00', '2024-04-09'),
(10, 'VEH020', 'PK010', '1616 Pham Van Dong', '15:00:00', '17:00:00', '2024-04-10'); 

CREATE USER 'sManager'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'sManager'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;

CREATE USER 'owner'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';

GRANT SELECT, UPDATE ON transport.owner_info TO 'owner'@'localhost';
GRANT SELECT, UPDATE ON transport.phone_number TO 'owner'@'localhost';
GRANT SELECT, UPDATE ON transport.person TO 'owner'@'localhost';
GRANT SELECT, UPDATE ON transport.private_vehicle TO 'owner'@'localhost';
GRANT SELECT, UPDATE ON transport.public_vehicle TO 'owner'@'localhost';

FLUSH PRIVILEGES;

DELIMITER //
CREATE PROCEDURE insert_owner_private_vehicle_info(
    IN owner_id VARCHAR(32),
    IN reg_id VARCHAR(32),
    IN brand varchar(32),
    IN plate_number varchar(32),
    IN vehicle_type varchar(32)
)
BEGIN
    -- Insert into table 
    INSERT INTO owner_info (owner_id) VALUES (owner_id) AS x
    ON DUPLICATE KEY UPDATE owner_id = x.owner_id;
    insert into vehicle (reg_id, brand, vehicle_age, owner_id) value (reg_id, brand, 0, owner_id) as x
    on duplicate key update vehicle_age = x.vehicle_age, owner_id = x.owner_id;
    insert into private_vehicle (reg_id, plate_number, vehicle_type) value (reg_id, plate_number, vehicle_type) as x
    on duplicate key update plate_number = x.plate_number;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InsertDemoData()
BEGIN
    DECLARE v_counter INT DEFAULT 11;  -- Start from 011
    WHILE v_counter <= 10000 DO  -- Change the upper limit to 10000
        INSERT INTO customer (ssi_passport, gender, age, customer_name, nationality)
        VALUES (
            CONCAT('SSI', LPAD(v_counter, 5, '0')),
            IF(FLOOR(RAND() * 2) = 0, 'Male', 'Female'), 
            FLOOR(RAND() * 100), 
            CONCAT('Customer ', v_counter), 
            IF(FLOOR(RAND() * 2) = 0, 'Vietnamese', 'Other')
        );
        SET v_counter = v_counter + 1;
    END WHILE;
END //
DELIMITER ;

CALL InsertDemoData();

DELIMITER //
CREATE PROCEDURE MeasureExecutionTime()
BEGIN
    DECLARE v_start_time DATETIME;
    DECLARE v_end_time DATETIME;
    DECLARE v_counter INT DEFAULT 0;

    SET v_start_time = NOW();

    -- Run the query multiple times
    WHILE v_counter < 30 DO
        SELECT * FROM customer WHERE customer_name = 'Customer 499';  -- Adjust as needed
        SET v_counter = v_counter + 1;
    END WHILE;

    SET v_end_time = NOW();
    SELECT TIMEDIFF(v_end_time, v_start_time) AS execution_time;
END //
DELIMITER ;

CALL MeasureExecutionTime();

CREATE INDEX idx_customer_name ON customer(customer_name);

delimiter $$
create function get_customer_total_weight_on_vehicle
				(
				SSI VARCHAR(9), 
				vehicle_ID VARCHAR(9), 
				get_on_time TIMESTAMP 
				)
			returns double 
        DETERMINISTIC
        begin 
			declare get_weight double; 
			set get_weight =  
				(
					select sum(weight) from belongs b 
					where b.ssi_passport = SSI 
							AND reg_id = vehicle_ID 
							AND b.get_on_time = get_on_time 
							ORDER BY b.ssi_passport 
				);
			return get_weight; 
        end;
$$
delimiter ; 

select get_customer_total_weight_on_vehicle('SSI001', 'VEH001', '2024-04-23 06:00:00');

delimiter //
CREATE PROCEDURE get_overweight_customer_from_time_bus
(
    IN bus_ID VARCHAR(32),
    IN from_time DATETIME, 
    IN to_time DATETIME 
) 
BEGIN
    IF from_time > NOW() THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid Time!';
    END IF; 

    IF to_time < from_time THEN  
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid Time! from_time > to_time';
    END IF; 

    SELECT customer.ssi_passport, 
           customer.customer_name, 
           customer.age, 
           customer.gender, 
           passenger.get_on_time, 
           public_vehicle.reg_id, 
           get_customer_total_weight_on_vehicle(customer.ssi_passport, public_vehicle.reg_id, passenger.get_on_time) AS total_weight
    FROM passenger
    JOIN customer ON passenger.ssi_passport = customer.ssi_passport
    JOIN public_vehicle ON passenger.reg_id = public_vehicle.reg_id
    LEFT JOIN belongs ON belongs.ssi_passport = passenger.ssi_passport 
                     AND belongs.get_on_time = passenger.get_on_time
                     AND belongs.reg_id = passenger.reg_id
    WHERE public_vehicle.vehicle_type = "Bus"
      AND public_vehicle.reg_id = bus_ID
      AND passenger.get_on_time BETWEEN from_time AND to_time
    GROUP BY customer.ssi_passport, passenger.get_on_time, passenger.reg_id
    HAVING total_weight > 10
    ORDER BY customer.ssi_passport, passenger.get_on_time;
END //
Delimiter ;

call get_overweight_customer_from_time_bus("VEH001","2024-04-23 06:00:00",NOW());

DELIMITER $$
CREATE FUNCTION get_expired_time (reg_id VARCHAR(32))
RETURNS VARCHAR(32) 
DETERMINISTIC
BEGIN
    DECLARE get_time INT;
    DECLARE output VARCHAR(32); 

    SET get_time = (
        SELECT MAX(
            CAST(
                TIMESTAMPDIFF(MONTH, NOW(), i.expired_date) AS SIGNED
            )
        )
        FROM insurance i 
        WHERE i.reg_id = reg_id 
          AND i.insurance_type = "REQ"
        GROUP BY reg_id
    );

    IF get_time > 12 THEN 
        SET output = CONCAT(FLOOR(get_time / 12), " YEARS");
    ELSEIF get_time > 0 THEN 
        SET output = CONCAT(get_time, " MONTHS"); 
    ELSE 
        SET output = "EXPIRED"; 
    END IF;

    RETURN output; 
END
$$
DELIMITER ;

select get_expired_time("VEH002");

