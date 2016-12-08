package Hubs;

import java.io.IOException;

/**
 *
 * @author Павел
 */

public class MalformedPacketException extends IOException {

	private static final long serialVersionUID = 4855167794892501538L;
	
	public MalformedPacketException(String message) {
		super(message);
	}
	
}
