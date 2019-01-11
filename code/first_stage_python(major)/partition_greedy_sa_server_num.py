import math
import time
import random
import itertools
def yield_subset(items):
	N = len(items)
	subset=[]

	for i in range(2**N):
		tmpset=[]
		for j in range(N):
			if(i >> j ) % 2 == 1:
				tmpset.append(items[j])
		if(len(tmpset)):
			subset.append(tmpset)
	return subset

def make_continue(list0):
	len0=len(list0)
	i=len0-1
	while(i>=0):
		sublen=len(list0[i])
		if (sublen>1):
			for j in range (sublen-1):
				if (list0[i][j]!=list0[i][j+1]-1):
					list0.remove(list0[i])
					break
		i=i-1
	return list0

def calculate_intersection_length(list1,list2):
	num=0
	len1=len(list1)
	for i in range (len1):
		if list1[i] in list2:
			num=num+1
	return num
def calculate_intersection_length2(list1,list2):
	num=0
	len2=len(list2)
	for i in range (len2):
		if list2[i] not in list1:
			num=num+1
	return num

def calculate_cost(alpha,beta,gama,n,d,cost_list,single_list,server_num):
	#cost1
	cost1 = alpha * (math.log(n, 2)) + beta * (math.log(d, 2)) + gama
	cost1 = (math.e) ** cost1
	#cost2
	length=len(single_list)
	cost2=0
	for i in range (length):
		cost2=cost2+cost_list[single_list[i]-1][server_num]
	#total_cost
	cost=cost1+cost2
	return cost

def random_server(n):
	result = []
	for i in range(n):
		tmp = []
		x1 = random.random()
		x2 = random.random()
		x3 = random.uniform(-4, -1)
		tmp.append(x1)
		tmp.append(x2)
		tmp.append(x3)
		result.append(tmp)
	return result

def random_single_cost(n,m):
	result = []

	for i in range(n):
		tmp = []
		for i in range(m):
			x = random.uniform(0, 30)
			tmp.append(x)
		result.append(tmp)

	return result

def rand_combine(selected_subset):
	if(len(selected_subset) > 1):
		comb = random.randint(0,len(selected_subset)-2)
		new_item =  [i for i in selected_subset[comb]] + [i for i in selected_subset[comb+1]]
		selected_subset.insert(comb,new_item)
		selected_subset.pop(comb+1)
		selected_subset.pop(comb+1)
		

def rand_decompose(selected_subset):
	decomp = random.randint(0,len(selected_subset)-1)
	decomp_index = random.randint(0,len(selected_subset[decomp])-1)
	c1 = selected_subset[decomp][0:decomp_index]
	c2 = selected_subset[decomp][decomp_index:]
	displacement = 0
	if(len(c2)>0):
		selected_subset.insert(decomp,c2)
		displacement += 1
	if(len(c1)>0):
		selected_subset.insert(decomp,c1)
		displacement += 1
	selected_subset.pop(decomp + displacement)

def board_partition(board,list0):
	result=[]
	tmp=[]
	length=len(board)

	for i in range(length):
		if (board[i]==0):
			tmp.append(list0[i])
		if(board[i]==1):
			tmp.append(list0[i])
			result.append(tmp)
			tmp=[]

	tmp.append(list0[length])
	result.append(tmp)

	return result

def yield_partition(list0):
	result=[]
	board=[]
	length=len(list0)

	if(length==1):
		tmp=list0
		result.append(tmp)
	else:
		for i in range(2**(length-1)):
			tmp=[]
			for j in range(length-1):
				tmp.append((i>>j)%2)
				if tmp not in board:
					board.append(tmp)

		board_kind=len(board)
		for i in range (board_kind):
			result0=board_partition(board[i],list0)
			result.append(result0)
	return result

def calculate_all_cost(partition,server_variable,single_cost,d,server_set,num_of_vnf):
	selected_server=[]
	selected_cost=[]
	selected_s = 0
	selected_c = 0
	pnum=len(partition)

	if pnum==1:
		flag = 999999
		server_choice = select_server(1, server_set)
		snum = len(server_choice)
		for j in range(snum):
			alpha = server_variable[server_choice[j][0]- 1][0]
			beta = server_variable[server_choice[j][0]- 1][1]
			gama = server_variable[server_choice[j][0]- 1][2]
			tmp = calculate_cost(alpha, beta, gama, 1, d, single_cost, partition[0], server_choice[j][0])

			if tmp < flag:
				flag = tmp
				selected_s = j
				selected_c = tmp

		selected_server.append(server_choice[selected_s])
		selected_cost.append(selected_c)




	else:
		for i in range(pnum):
			server_choice = select_server(len(partition[i]), server_set)

			snum = len(server_choice)
			flag=999999
			for j in range(snum):
				tmp=0
				for k in range(len(partition[i])):
					n=len(partition[i][k])
					alpha=server_variable[server_choice[j][k]-1][0]
					beta=server_variable[server_choice[j][k]-1][1]
					gama=server_variable[server_choice[j][k]-1][2]
					tmp=tmp+calculate_cost(alpha,beta,gama,n,d,single_cost,partition[i][k],server_choice[j][k]-1)

				if tmp<flag:
					flag=tmp
					selected_s=j
					selected_c=tmp

			selected_server.append(server_choice[selected_s])
			selected_cost.append(selected_c)


	selected_p=selected_cost.index(min(selected_cost))
	#print("cost",selected_cost[selected_p])
	#print("partition",partition[selected_p])
	#print("server",selected_server[selected_p])
	return selected_cost[selected_p]

def select_server(num,lst):
	result=[]
	for element in itertools.combinations_with_replacement(lst,num):
		tmp=list(element)
		result.append(tmp)
	for i in range(len(result)):
		for item in itertools.permutations(result[i],len(result[i])):
			item=list(item)
			if item not in result:
				result.append(item)
	return result

def main():
	num_of_vnf = 3
	test_times = 8
	list_server = [5,15,25,35,45]
	for num_of_server in list_server:
		test_times -= 1
		cost_optimal = 0
		time_optimal = 0
		cost_greedy = 0
		time_greedy = 0
		cost_sa = 0
		time_sa = 0
		vnf_set = list(range(1,num_of_vnf+1))
		server_set = []
		for i in range(num_of_server):
			server_set.append(i + 1)
		for k in range(test_times):
			server_variable = random_server(num_of_server)
			single_cost = random_single_cost(num_of_vnf, num_of_server)


			d = 20



			vnf_subset=yield_subset(vnf_set)
			vnf_subset=make_continue(vnf_subset)


		#greedy start
			x=[]
			for item in vnf_set:
				x.append(item)

			selected_index=[]
			selected_subset = []
			selected_server=[]
			selected_cost=[]

			time1=time.time()

			while(len(x)):
				flag=0
				server_flag=0
				cost_flag = 0
				subset_flag=0
				for i in range(num_of_server):
					for j in range(len(vnf_subset)):	
						alpha=server_variable[i][0]
						beta=server_variable[i][1]
						gama=server_variable[i][2]
						intersection_length=calculate_intersection_length(vnf_subset[j],x)
						cost=calculate_cost(alpha,beta,gama,len(vnf_subset[j]),d,single_cost,vnf_subset[j],i)
						tmp=intersection_length/cost
						if(tmp>flag):
							server_flag=server_set[i]
							subset_flag=j
							cost_flag=cost
							flag=tmp
				for element in vnf_subset[subset_flag]:
					if element in x:
						x.remove(element)

				selected_index.append(subset_flag)
				selected_subset.append(vnf_subset[subset_flag])
				selected_server.append(server_flag)
				selected_cost.append(cost_flag)

			#print(selected_index)
			#print(selected_subset)
		   # print(selected_server)
		   # print(selected_cost)

			total_cost=0
			for i in range(len(selected_cost)):
				total_cost=total_cost+selected_cost[i]

			time2=time.time()
			time3=time2-time1

			distribute_result=[0]*num_of_vnf

			for i in range(len(selected_subset)):
				for j in range(len(selected_subset[i])):
					element=selected_subset[i][j]
					if (distribute_result[element-1]==0):
						distribute_result[element-1]=selected_server[i]

			#print("greedy:")
			#print ("distribute_result",distribute_result)
			#print ("cost",total_cost)
			cost_greedy += total_cost
			#print ("time",time3)
			#print()
			time_greedy += time3
		#Greedy end

		#simulated annealing  start
			x=[]
			for item in vnf_set:
				x.append(item)

			selected_index=[]
			selected_subset=[[i] for i in vnf_set]
			selected_server=[]
			selected_cost= 99999

			time1=time.time()
			temperature = 100
			limit = 0.1
			decay = 0.99
			max_iter = 200
			steps = 0
			while(temperature > limit):
				last = selected_subset.copy()
				combine_or_decompose = random.randint(0,1)
				if(combine_or_decompose == 0):
					rand_combine(selected_subset)
				else:
					rand_decompose(selected_subset)

				servers = []
				t_cost = 0
				for i in range(len(selected_subset)):
					cost_flag = 99999
					server_flag = -1
					for j in range(num_of_server):
						alpha=server_variable[j][0]
						beta=server_variable[j][1]
						gama=server_variable[j][2]
						cost=calculate_cost(alpha,beta,gama,len(selected_subset[i]),d,single_cost,selected_subset[i],j)
						if(cost<cost_flag):
							cost_flag = cost
							server_flag = server_set[j]
					t_cost += cost_flag
					servers.append(server_flag)
				if(t_cost < selected_cost):
					selected_cost = t_cost
					selected_server = servers.copy()
				else:
					pr = math.exp((selected_cost-t_cost)/temperature)
					#print(pr)
					if(random.random()<pr):
						selected_cost = t_cost
						selected_server = servers.copy()
					else:
						selected_subset = last.copy()
					steps += 1
					if(steps%max_iter==0):
						temperature *=decay



			#print(selected_index)
			#print(selected_subset)
		   # print(selected_server)
		   # print(selected_cost)

			total_cost=selected_cost

			time2=time.time()
			time3=time2-time1

			distribute_result=[0]*num_of_vnf

			for i in range(len(selected_subset)):
				for j in range(len(selected_subset[i])):
					element=selected_subset[i][j]
					if (distribute_result[element-1]==0):
						distribute_result[element-1]=selected_server[i]
			#print("simulated annealing:")
			#print ("distribute_result",distribute_result)
			#print ("cost",total_cost)
			cost_sa += total_cost
			#print ("time",time3)
			time_sa += time3
			#print()
		#simulated annealing end
			#print("Optimal result:")
			d=20

			time1=time.time()

			partition = yield_partition(vnf_set)
			cost_optimal += calculate_all_cost(partition,server_variable,single_cost,d,server_set,num_of_vnf)

			time2=time.time()
			time3=time2-time1
			time_optimal += time3
			#print ("time",time3)
		print("Server:"+str(num_of_server))
		print("Cost for optimal:"+str(cost_optimal/test_times))
		print("Time for optimal:"+str(time_optimal/test_times))
		print("Cost for greedy:"+str(cost_greedy/test_times))
		print("Time for greedy:"+str(time_greedy/test_times))
		print("Cost for sa:"+str(cost_sa/test_times))
		print("Time for sa:"+str(time_sa/test_times))
main()
