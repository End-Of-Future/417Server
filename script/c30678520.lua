--自律部队·前线作战基地
local m=30678520
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.mfilter,1)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.tkcon)
	e1:SetTarget(cm.tktg)
	e1:SetOperation(cm.tkop)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,30678521)
	e4:SetTarget(cm.settg)
	e4:SetOperation(cm.setop)
	c:RegisterEffect(e4)



end
function cm.mfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:GetLink()>=1 and c:IsSetCard(0xc13) and not c:IsLinkCode(m)
end








function cm.setfilter(c)
	return c:IsCode(30679000) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.setfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,cm.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)
	end
end









function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()~=1 then return false end
	if chk==0 then return mg:IsExists(Card.IsType,1,nil,TYPE_LINK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,30678525,0xc13,TYPES_TOKEN_MONSTER,0,0,4,RACE_MACHINE,ATTRIBUTE_EARTH) end
	e:SetLabel(mg:GetFirst():GetLink())
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=e:GetLabel()
	if ft>0 and ct>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,30678525,0xc13,TYPES_TOKEN_MONSTER,0,0,4,RACE_MACHINE,ATTRIBUTE_EARTH) then
		local count=math.min(ft,ct)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then count=1 end
		if count>1 then
			local num={}
			local i=1
			while i<=count do
				num[i]=i
				i=i+1
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
			count=Duel.AnnounceNumber(tp,table.unpack(num))
		end
		repeat
			local token=Duel.CreateToken(tp,30678525)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			count=count-1
		until count==0
		Duel.SpecialSummonComplete()
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.splimit(e,c)
	return not c:IsSetCard(0xc13)
end