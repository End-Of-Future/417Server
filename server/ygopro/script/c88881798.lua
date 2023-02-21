--贝利尔 世荒的天灾[M]
function c88881798.initial_effect(c) 
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)  
	e1:SetCondition(c88881798.XyzCondition(nil,8,3,99))
	e1:SetTarget(c88881798.XyzTarget(nil,8,3,99))
	e1:SetOperation(c88881798.XyzOperation(nil,8,3,99)) 
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	c:EnableReviveLimit() 
	--zone limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MUST_USE_MZONE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE) 
	e0:SetCondition(function(e) 
	return e:GetHandler():GetFlagEffect(88881798)~=0 end)
	e0:SetValue(c88881798.zonelimit)
	c:RegisterEffect(e0)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION) 
	c:RegisterEffect(e0) 
	--spsummon token
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
	e0:SetOperation(c88881798.xspop)
	c:RegisterEffect(e0)
	--disable field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(c88881798.disval)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c88881798.reptg)
	c:RegisterEffect(e2)
end
function c88881798.XyzCondition(f,lv,minc,maxc)
	--og: use special material
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minc 
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
	local zone_check=false 
	for i=1,3 do 
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc and not tc:IsCanBeXyzMaterial(c) then
		else 
			local tc1=Duel.GetFieldCard(tp,LOCATION_MZONE,i-1) 
			local tc2=Duel.GetFieldCard(tp,LOCATION_MZONE,i+1)
			if (tc1 and not tc1:IsCanBeXyzMaterial(c)) or (tc2 and not tc2:IsCanBeXyzMaterial(c)) then 
			else
				zone_check=true
			end
		end
	end 
	if not zone_check or not Duel.IsPlayerCanSpecialSummonCount(tp,2) or not Duel.IsPlayerCanSpecialSummonMonster(tp,88881799,0,TYPE_XYZ+TYPE_MONSTER,4000,4000,8,RACE_DRAGON,ATTRIBUTE_DARK,POS_FACEUP) or not Duel.IsPlayerCanSpecialSummonMonster(tp,88881800,0,TYPE_XYZ+TYPE_MONSTER,4000,4000,8,RACE_DRAGON,ATTRIBUTE_DARK,POS_FACEUP)
	or Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
				return Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og) 
			end
end
function c88881798.XyzTarget(f,lv,minc,maxc)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				c:RegisterFlagEffect(88881798,RESET_EVENT+RESETS_STANDARD,0,1)
				local g=Duel.SelectXyzMaterial(tp,c,f,lv,minc,maxc,og)
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function c88881798.XyzOperation(f,lv,minc,maxc)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					local sg=Group.CreateGroup()
					local tc=mg:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=mg:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()  
				end
			end
end
function c88881798.zonelimit(e)
	local tp=e:GetHandlerPlayer()
	local zone=0 
	local tc0=Duel.GetFieldCard(tp,LOCATION_MZONE,0)
	local tc1=Duel.GetFieldCard(tp,LOCATION_MZONE,1)
	local tc2=Duel.GetFieldCard(tp,LOCATION_MZONE,2)
	local tc3=Duel.GetFieldCard(tp,LOCATION_MZONE,3)
	local tc4=Duel.GetFieldCard(tp,LOCATION_MZONE,4)
	if (not tc2 or tc2:IsCanBeXyzMaterial(e:GetHandler())) and (not tc0 or tc0:IsCanBeXyzMaterial(e:GetHandler())) then zone=zone|0x2 end
	if (not tc3 or tc3:IsCanBeXyzMaterial(e:GetHandler())) and (not tc1 or tc1:IsCanBeXyzMaterial(e:GetHandler())) then zone=zone|0x4 end
	if (not tc4 or tc4:IsCanBeXyzMaterial(e:GetHandler())) and (not tc2 or tc2:IsCanBeXyzMaterial(e:GetHandler())) then zone=zone|0x8 end
	return zone 
end 
function c88881798.xspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP) and c:IsCode(88881799,88881800)  
end  
function c88881798.xspgck(g,tp) 
	return g:FilterCount(Card.IsCode,nil,88881799)==1 
	   and g:FilterCount(Card.IsCode,nil,88881800)==1  
end 
function c88881798.xspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88881798.xspfil,tp,LOCATION_EXTRA,0,nil,e,tp) 
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,(1<<(e:GetHandler():GetSequence()+1)))>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,(1<<(e:GetHandler():GetSequence()-1)))>0
		and g:CheckSubGroup(c88881798.xspgck,2,2,tp) then  
		local sg=g:Select(tp,c88881798.xspgck,false,2,2,tp)
		local tc=sg:GetFirst() 
		while tc do 
			local seq=e:GetHandler():GetSequence() 
			local seq_i=(1<<(seq-1))
			if tc:IsCode(88881799) then
				seq_i=(1<<(seq-1))
			else
				seq_i=(1<<(seq+1))
			end 
			Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP,seq_i) 
			local og=c:GetOverlayGroup() 
			if og:GetCount()>0 then 
				local xog=og:Select(tp,1,1,nil)
				Duel.Overlay(tc,xog) 
			end 
		tc=sg:GetNext() 
		end 
		Duel.SpecialSummonComplete()
	else
		Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
	end
end 
function c88881798.disval(e)
	local c=e:GetHandler() 
	local tp=e:GetHandlerPlayer()
	local seq=c:GetSequence()
	local zone=0
	local val1=aux.SequenceToGlobal(1-tp,LOCATION_SZONE,4-seq)
	local val2=aux.SequenceToGlobal(1-tp,LOCATION_MZONE,4-seq)
	zone=bit.bor(zone,val1)
	zone=bit.bor(zone,val2)  
	if seq==1 then zone=bit.bor(zone,4194336) end 
	if seq==3 then zone=bit.bor(zone,2097216) end 
	return zone 
end
function c88881798.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end





