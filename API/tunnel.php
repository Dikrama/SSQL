<?php	
	//koneksi db	
	$Token = "53713";
	$Host = $_POST['host'];
	$User = $_POST['user'];
	$Pass = $_POST['pass'];
	$DB	  = $_POST['DB'];
	$konak = mysqli_connect($Host, $User, $Pass, $DB);
	
	if ($Token === $_POST['tokenid']) {
	if($konak === false){
	    die('[{"Error description":"'. mysqli_error($konak).'"}]');
	} else {
		//loader 
	$query =$_POST['par'];
	$findstr='elect';
	$pos=strpos ($query, $findstr);
	if (strpos ($query, $findstr) >0) {
		if($qq = mysqli_query($konak, $query)){
			
			 while ($row = mysqli_fetch_assoc($qq)) {
				$data[] = $row;
				}
			$jml = mysqli_num_rows($qq);

			If ($jml==0) {
					echo '[{"result":"no data"}]';}     
					else echo json_encode($data); 
			} else {
				echo  '[{"Error description":"'. mysqli_error($konak).'"}]';
				} 				
				} else { 
					if(mysqli_query($konak, $query)); echo $pos;
				} 				
				}
			} else { echo '[{"Error description":"Invalid Token"}]';		
		}

	
?>
