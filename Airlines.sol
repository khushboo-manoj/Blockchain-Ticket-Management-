// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.6;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    /**
     * @dev Multiplies two numbers, throws on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
     * @dev Integer division of two numbers, truncating the quotient.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }

    /**
     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /**
     * @dev Adds two numbers, throws on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

contract escrowContract {
    
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

        event Log(string message);
        event Log(uint256 price);
        
    receive() external payable {}

    function transferAmount (address payable to_address, uint256 price)
        external payable
    {
        emit Log("Transfer");
        emit Log(price);
        
        to_address.transfer(price);
    }

}

//////////////////////////////////////////////////////////////////////////////////////////////////////


contract airlineContract {
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable{}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////
contract Airlines {
    receive() external payable {
        balance += msg.value;
    }

    event Log(string message);
    event Log(uint256 price);

    using SafeMath for uint256;

    address public owner;
    uint256 public balance;

    enum FlightStatus {
        OnTime, //0
        Cancelled, // 1
        Delayed, //2
        Completed //3
    }

    enum ContractState {
        INITIATED,
        INITIATOR_PAID,
        TRAVELLED,
        VENDOR_PAID,
        CANCELLED
    }

    /*
    enum SeatTypeChoice {
        Economy,
        Business
    }

    enum SeatChoice {
        Window,
        Middle,
        Aisle
    }
    */

    escrowContract public escrow_contract; 
    address payable public escrow_account_address;

    constructor(address payable _address) {
        owner = msg.sender;
        escrow_account_address = _address;
        escrow_contract = escrowContract(escrow_account_address);
    }

    function stringsEquals(string memory s1, string memory s2)
        private
        pure
        returns (bool)
    {
        bytes memory b1 = bytes(s1);
        bytes memory b2 = bytes(s2);
        uint256 l1 = b1.length;
        if (l1 != b2.length) return false;
        for (uint256 i = 0; i < l1; i++) {
            if (b1[i] != b2[i]) return false;
        }
        return true;
    }

    //address payable public escrow_account;

    //address payable escrow_account_address;

    //function setEscrowContractAddress(address _address) public {
      //  escrow_account_address = payable(_address);
    //}

    //escrowContract escrow_contract = escrowContract(escrow_account_address);


    function getEscrowBalance() public view returns(uint256){
        return escrow_contract.getBalance();
    }

    struct AirlineData {
        uint256 airline_id;
        address airline_owner;
        string airline_name;
    }

    uint256 constant_airline_id = 0;

    address payable airlineAddress;
    function setAirlineAddress(address payable airline_address) public {
        airlineAddress = airline_address;
    }

    AirlineData airline1 =
        AirlineData({
            airline_id: constant_airline_id++,
            airline_owner: 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db,
            airline_name: "Eagle Airlines"
        });

    AirlineData[] public airlines;

    function add_airlines() public {
        airlines.push(airline1);
    }

    function add_new_airline(
        address i_airline_owner,
        string memory i_airline_name
    ) public {
        AirlineData memory new_airline = AirlineData({
            airline_id: constant_airline_id++,
            airline_owner: payable(i_airline_owner),
            airline_name: i_airline_name
        });
        airlines.push(new_airline);
    }

    function getAllAirlines() public view returns (AirlineData[] memory) {
        return airlines;
    }

    function getAirlineByID(uint256 airline_id)
        public
        view
        returns (AirlineData memory)
    {
        return airlines[airline_id];
    }

    FlightData[] in_flights;
    uint256 constant_flight_id = 0;

    struct FlightData {
        string airline_name;
        uint256 flight_id;
        string from;
        string to;
        uint256 price;
        uint256 total_seat_count;
        uint256 booked_seat_count;
        uint256 departure_time;
        uint256 arrival_time;
        uint256 flight_status;
    }

    FlightData flight1 =
        FlightData(
            "Eagle Airlines",
            constant_flight_id++,
            "Delhi",
            "Mumbai",
            200,
            45,
            0,
            1670097761,
            1670197761,
            0
        );
    FlightData flight2 =
        FlightData(
            "Eagle Airlines",
            constant_flight_id++,
            "Delhi",
            "Banglore",
            300,
            45,
            0,
            1670097761,
            1670197761,
            0
        );

    function addFlights() public {
        in_flights.push(flight1);
        in_flights.push(flight2);
    }

    function add_new_flights(
        string memory i_airline_name,
        string memory i_from,
        string memory i_to,
        uint256 i_price,
        uint256 i_total_seat_count,
        uint256 i_booked_seat_count,
        uint256 i_departure_time,
        uint256 i_arrival_time,
        uint256 i_flight_status
    ) public returns (FlightData memory) {
        FlightData memory new_flight = FlightData({
            airline_name: i_airline_name,
            flight_id: constant_flight_id++,
            from: i_from,
            to: i_to,
            price: i_price,
            total_seat_count: i_total_seat_count,
            booked_seat_count: i_booked_seat_count,
            departure_time: i_departure_time,
            arrival_time: i_arrival_time,
            flight_status: i_flight_status
        });

        in_flights.push(new_flight);
        return new_flight;
    }

    function getFlights() public view returns (FlightData[] memory) {
        return in_flights;
    }

    function getFlightsByAirline(string memory i_airline_name)
        public
        view
        returns (FlightData[] memory)
    {
        FlightData[] memory outFlights = new FlightData[](in_flights.length);
        uint8 x = 0;
        for (uint256 i = 0; i < in_flights.length; i++) {
            if (stringsEquals(in_flights[i].airline_name, i_airline_name)) {
                outFlights[x] = (in_flights[i]);
                x++;
            }
        }
        return outFlights;
    }

    function getFlightsByFlightID(uint256 i_flight_id)
        public
        view
        returns (FlightData memory)
    {
        return in_flights[i_flight_id];
    }

    uint256 constant_ticket_id = 0;

    struct Ticket {
        uint256 ticket_id;
        ContractState state;
        address payable initiator;
        string initiator_name;
        string airline_name;
        uint256 flight_id;
        uint256 booked_datetime;
        uint256 ticket_qty;
        uint256 ticket_price;
        bool is_cancelled;
    }

    Ticket[] all_tickets;

    function bookFlight(
        string memory i_initiator_name,
        string memory i_airline_name,
        uint256 i_flight_id
    ) public returns (Ticket memory) {
        uint256 x = 0;
        bool correctAirline = false;

        while (x < airlines.length) {
            if (stringsEquals(i_airline_name, airlines[x].airline_name)) {
                correctAirline = true;
                break;
            } else {
                x++;
            }
        }

        uint256 y = 0;
        bool correctFlight = false;
        FlightData memory currentFlight;

        while (y < in_flights.length) {
            if (
                stringsEquals(i_airline_name, in_flights[y].airline_name) &&
                i_flight_id == in_flights[y].flight_id
            ) {
                currentFlight = in_flights[y];
                correctFlight = true;
                in_flights[y];
                break;
            } else {
                y++;
            }
        }

        //if condition
        emit Log("Transfer to escrow");
        emit Log(currentFlight.price);
        escrow_account_address.transfer(currentFlight.price);
        emit Log("Transfer successful");
        Ticket memory new_ticket = Ticket({
            ticket_id: constant_ticket_id,
            state: ContractState.INITIATED,
            initiator: payable(msg.sender),
            initiator_name: i_initiator_name,
            airline_name: i_airline_name,
            flight_id: i_flight_id,
            booked_datetime: block.timestamp,
            ticket_qty: 1,
            ticket_price: currentFlight.price,
            is_cancelled: false
        });
        constant_ticket_id += 1;
        all_tickets.push(new_ticket);
        return new_ticket;
    }

    function getBookedFlights() public view returns (Ticket[] memory) {
        return all_tickets;
    }

    function getTicketByID(uint256 ticket_id)
        public
        view
        returns (Ticket memory)
    {
        return all_tickets[ticket_id];
    }

    Ticket tempArray;


    function changeFlightStatus(
        string memory i_airline_name,
        uint256 i_airline_id,
        uint256 i_flight_id,
        uint256 new_flight_status,
        uint256 new_departure_time
    ) public payable {
        address payable airline_address = payable(
            airlines[i_airline_id].airline_owner
        );
        uint256 pay_to_customer = 0;
        uint256 pay_to_airlines = 0;

        // get correct flight
        uint256 total_price = in_flights[i_flight_id].price;
        uint256 initial_state = in_flights[i_flight_id].flight_status;
        uint256 initial_departure_time = in_flights[i_flight_id].departure_time;
        in_flights[i_flight_id].flight_status = new_flight_status;

        // for all ticket bookings for the flight add money
        for (uint256 x = 0; x < constant_ticket_id; x++) {
            if (
                all_tickets[x].flight_id == i_flight_id &&
                stringsEquals(all_tickets[x].airline_name, i_airline_name) &&
                all_tickets[x].is_cancelled != true
            ) {
                emit Log("Found ticket");
                address payable customer = all_tickets[x].initiator;
                if (initial_state == 0) {
                    // flight cancelled  - transfer complete price back to customer
                    if (new_flight_status == 1) {
                        emit Log("Transfer to customer");
                        escrow_contract.transferAmount(customer, total_price);
                        //customer.transfer(total_price);
                    }
                    // flight delayed - change the initial state to delayed
                    else if (new_flight_status == 2) {
                        emit Log("Flight Delayed : Status changed");
                        //log this
                    }
                    // flight complete from on time - transfer complete amount to airline
                    else if (new_flight_status == 3) {
                        emit Log("Flight Complete");
                        emit Log("Transfer to airlines");

                        pay_to_airlines += total_price;
                    }
                }
                //flight completed from delayed status - transfer % of amount to airline and the rest to customer
                else if (initial_state == 2) {
                    uint256 difference = new_departure_time -
                        initial_departure_time;
                    if (new_flight_status == 3) {
                        // if flight is delayed by more than a day
                        if (difference > 86400) {
                            pay_to_airlines += (3 * total_price) / 10;
                            pay_to_customer = (7 * total_price) / 10;
                            emit Log("Transfer to customer");
                            escrow_contract.transferAmount(
                                customer,
                                pay_to_customer
                            );
                            //customer.transfer(pay_to_customer);
                        }
                        // if flight is delayed by more than 6 hours and less than a day
                        else if (difference > 21600 && difference <= 86400) {
                            pay_to_airlines += (5 * total_price) / 10;
                            pay_to_customer = (5 * total_price) / 10;
                            emit Log("Transfer to customer");

                            escrow_contract.transferAmount(
                                customer,
                                pay_to_customer
                            );
                            //customer.transfer(pay_to_customer);
                        }
                        // if flight is delayed by more than 1 hours and less than 6 hours
                        else if (difference > 3600 && difference <= 21600) {
                            pay_to_airlines += (7 * total_price) / 10;
                            pay_to_customer = (3 * total_price) / 10;
                            emit Log("Transfer to customer");

                            escrow_contract.transferAmount(
                                customer,
                                pay_to_customer
                            );
                            //customer.transfer(pay_to_customer);
                        }
                        // if flight is delayed by less than 1 hour
                        else if (difference <= 3600) {
                            pay_to_airlines += (9 * total_price) / 10;
                            pay_to_customer = total_price / 10;
                            emit Log("Transfer to customer");

                            escrow_contract.transferAmount(
                                customer,
                                pay_to_customer
                            );
                            //customer.transfer(pay_to_customer);
                        }
                    }
                }
            }
        }

        if (pay_to_airlines > 0) {
            emit Log("Initiating Payment to airlines");
            escrow_contract.transferAmount(airline_address, pay_to_airlines);
            emit Log("Payment Successful");
            pay_to_airlines = 0;
        }
    }

    function cancelTicket(uint256 i_airline_id, uint256 i_flight_id, uint256 ticket_id, uint256 i_cancellation_time)
        public
        returns (bool)
    {
        uint256 cancellation_time = i_cancellation_time;
        //uint256 cancellation_time = block.timestamp;
        uint256 flight_departure_time = in_flights[i_flight_id].departure_time;
        address payable airline_address = payable(airlines[i_airline_id].airline_owner);
      
        uint256 flight_difference = flight_departure_time - cancellation_time;
        if(all_tickets[ticket_id].is_cancelled != true && flight_difference >=86400){
              emit Log("Transfer to customer");
            escrow_contract.transferAmount(
                all_tickets[ticket_id].initiator,
                all_tickets[ticket_id].ticket_price
            );
            return true;
        }
        else if (all_tickets[ticket_id].is_cancelled != true && flight_difference > 7200  && flight_difference < 86400) {
            
            emit Log("Transfer to customer");
            escrow_contract.transferAmount(
                all_tickets[ticket_id].initiator,
                (8 * all_tickets[ticket_id].ticket_price) / 10
            );
            emit Log("Transfer to Airlines");
            escrow_contract.transferAmount(
                airline_address,
                (2 * all_tickets[ticket_id].ticket_price) / 10
            );
            all_tickets[ticket_id].is_cancelled = true;
            return true;
        } else {
            emit Log("Cancellation not possible");
            return false;
        }
    }
}
